-- Migration: Full RLS lockdown across all Supabase tables
-- Issue: #86 – database-backed RLS policies audit
-- Every table gets ENABLE ROW LEVEL SECURITY plus explicit policies.
-- Server-side paths (Edge Functions / API routes) use the service-role key
-- and are exempt from RLS by Postgres design.

-- Helper: extract wallet address from the JWT sub claim.
-- Used in every policy so we keep the pattern consistent.

-- ============================================================
-- pools
-- ============================================================
ALTER TABLE public.pools ENABLE ROW LEVEL SECURITY;

-- Public read (explore page works without a wallet)
CREATE POLICY "pools_select_public"
  ON public.pools FOR SELECT
  USING (true);

-- Only the creator can insert their own pool
CREATE POLICY "pools_insert_own"
  ON public.pools FOR INSERT
  WITH CHECK (
    creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- Only the creator can update
CREATE POLICY "pools_update_own"
  ON public.pools FOR UPDATE
  USING (
    creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- Only the creator can delete
CREATE POLICY "pools_delete_own"
  ON public.pools FOR DELETE
  USING (
    creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- ============================================================
-- pool_members
-- ============================================================
ALTER TABLE public.pool_members ENABLE ROW LEVEL SECURITY;

-- Members of the pool or the pool creator can read membership
CREATE POLICY "pool_members_select"
  ON public.pool_members FOR SELECT
  USING (
    member_address = current_setting('request.jwt.claims', true)::json->>'sub'
    OR EXISTS (
      SELECT 1 FROM public.pools
      WHERE pools.id = pool_members.pool_id
        AND pools.creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );

-- INSERT / UPDATE / DELETE only via service-role key (no user-facing policy)
-- This means anon and authenticated users cannot write to pool_members.

-- ============================================================
-- pool_activity
-- ============================================================
ALTER TABLE public.pool_activity ENABLE ROW LEVEL SECURITY;

-- Pool members and creator can read activity
CREATE POLICY "pool_activity_select"
  ON public.pool_activity FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.pool_members
      WHERE pool_members.pool_id = pool_activity.pool_id
        AND pool_members.member_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
    OR EXISTS (
      SELECT 1 FROM public.pools
      WHERE pools.id = pool_activity.pool_id
        AND pools.creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );

-- All writes are blocked for non-service-role callers (no INSERT/UPDATE/DELETE policy).

-- ============================================================
-- pool_daily_metrics
-- ============================================================
ALTER TABLE public.pool_daily_metrics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "pool_daily_metrics_select"
  ON public.pool_daily_metrics FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.pool_members
      WHERE pool_members.pool_id = pool_daily_metrics.pool_id
        AND pool_members.member_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
    OR EXISTS (
      SELECT 1 FROM public.pools
      WHERE pools.id = pool_daily_metrics.pool_id
        AND pools.creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );

-- ============================================================
-- pool_health_scores
-- ============================================================
ALTER TABLE public.pool_health_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "pool_health_scores_select"
  ON public.pool_health_scores FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.pool_members
      WHERE pool_members.pool_id = pool_health_scores.pool_id
        AND pool_members.member_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
    OR EXISTS (
      SELECT 1 FROM public.pools
      WHERE pools.id = pool_health_scores.pool_id
        AND pools.creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );

-- ============================================================
-- user_profiles
-- ============================================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Only the profile owner can read their own row
CREATE POLICY "user_profiles_select_own"
  ON public.user_profiles FOR SELECT
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

CREATE POLICY "user_profiles_insert_own"
  ON public.user_profiles FOR INSERT
  WITH CHECK (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

CREATE POLICY "user_profiles_update_own"
  ON public.user_profiles FOR UPDATE
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

CREATE POLICY "user_profiles_delete_own"
  ON public.user_profiles FOR DELETE
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- ============================================================
-- notifications
-- ============================================================
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notifications_select_own"
  ON public.notifications FOR SELECT
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- Owner can mark notifications as read or delete them
CREATE POLICY "notifications_update_own"
  ON public.notifications FOR UPDATE
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

CREATE POLICY "notifications_delete_own"
  ON public.notifications FOR DELETE
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- INSERT is blocked for non-service-role callers (created by Edge Functions only).

-- ============================================================
-- join_requests  (drop old policies, replace with complete set)
-- ============================================================
ALTER TABLE public.join_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can create join requests" ON public.join_requests;
DROP POLICY IF EXISTS "Pool creator can view join requests" ON public.join_requests;

-- Requester can see their own requests; pool creator can see all requests for their pool
CREATE POLICY "join_requests_select"
  ON public.join_requests FOR SELECT
  USING (
    requester_address = current_setting('request.jwt.claims', true)::json->>'sub'
    OR EXISTS (
      SELECT 1 FROM public.pools
      WHERE pools.id = join_requests.pool_id
        AND pools.creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );

-- Authenticated caller can only submit a request as themselves
CREATE POLICY "join_requests_insert_own"
  ON public.join_requests FOR INSERT
  WITH CHECK (
    requester_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- Only the pool creator can accept/decline (prevents self-approval)
CREATE POLICY "join_requests_update_creator"
  ON public.join_requests FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.pools
      WHERE pools.id = join_requests.pool_id
        AND pools.creator_address = current_setting('request.jwt.claims', true)::json->>'sub'
    )
  );

-- Requester can withdraw their own pending request
CREATE POLICY "join_requests_delete_own"
  ON public.join_requests FOR DELETE
  USING (
    requester_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- ============================================================
-- deposit_reminders
-- ============================================================
ALTER TABLE public.deposit_reminders ENABLE ROW LEVEL SECURITY;

-- Owner can read their own reminders
CREATE POLICY "deposit_reminders_select_own"
  ON public.deposit_reminders FOR SELECT
  USING (
    wallet_address = current_setting('request.jwt.claims', true)::json->>'sub'
  );

-- INSERT / UPDATE / DELETE only via service-role key (Edge Function).
