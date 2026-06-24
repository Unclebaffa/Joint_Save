# Row Level Security – Access Model

This document records the intended access model for every Supabase table in
JointSave. All tables have RLS explicitly enabled. The companion migration is
`supabase/migrations/20260624000000_rls_lockdown.sql`.

---

## Auth assumption

JointSave authenticates users by wallet address. The wallet address is stored
as the `sub` claim in the Supabase JWT (populated by the Edge Functions and API
routes that issue tokens). All policies extract the caller's identity via:

```sql
current_setting('request.jwt.claims', true)::json->>'sub'
```

Writes that must bypass RLS (e.g. Edge Functions running with the service-role
key) are exempt from all policies by Postgres design.

---

## Table-by-table access model

### `pools`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Anyone (anon) | Pool listings are public; the Explore page reads pools without a wallet. |
| INSERT    | Authenticated caller whose `creator_address` matches their JWT `sub` | Prevents one user creating a pool on behalf of another. |
| UPDATE    | Pool creator only | Only the creator manages pool metadata. |
| DELETE    | Pool creator only | Creator can archive their own pool. |

### `pool_members`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Members of the pool OR the pool creator | Membership lists are semi-private; outsiders should not enumerate wallet addresses of a pool's members. |
| INSERT    | Pool creator only (server-side path) | Membership is granted by the creator or via an accepted `join_request`; the API route uses the service-role key. |
| UPDATE    | Pool creator only | Status changes (pending → paid) are managed server-side. |
| DELETE    | Pool creator only | Removing a member is an admin action. |

### `pool_activity`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Members of the pool OR the pool creator | Activity feeds are visible to participants. |
| INSERT    | Blocked for anon/authenticated users | All activity rows are written by server-side Edge Functions using the service-role key. Prevents users faking activity. |
| UPDATE / DELETE | Blocked | Activity is an immutable audit log. |

### `pool_daily_metrics`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Members of the pool OR the pool creator | Analytics are internal to the pool. |
| INSERT / UPDATE / DELETE | Blocked | Written exclusively by scheduled Edge Functions with the service-role key. |

### `pool_health_scores`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Members of the pool OR the pool creator | Health scores are pool-internal. |
| INSERT / UPDATE / DELETE | Blocked | Written by scheduled Edge Functions. |

### `user_profiles`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Owner only (wallet = JWT sub) | Email and notification prefs are private; no other user should be able to read another wallet's email. |
| INSERT    | Owner only | A user creates their own profile. |
| UPDATE    | Owner only | A user updates their own prefs. |
| DELETE    | Owner only | A user can delete their own profile. |

### `notifications`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Owner only (wallet_address = JWT sub) | Notification feed is per-user and private. |
| INSERT    | Blocked for anon/authenticated users | Notifications are created by Edge Functions with the service-role key. |
| UPDATE    | Owner only | Users can mark their own notifications as read. |
| DELETE    | Owner only | Users can clear their own notifications. |

### `join_requests`

Already had partial RLS from a previous migration. Policies are replaced here
for completeness and to enforce write-side consistency.

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Requester OR pool creator | Both parties need visibility. |
| INSERT    | Authenticated caller whose `requester_address` matches JWT sub | Prevents submitting a request as someone else. |
| UPDATE    | Pool creator only | Only the creator can accept/decline. Prevents self-approval. |
| DELETE    | Requester (own pending request) | Allows withdrawal of an unanswered request. |

### `deposit_reminders`

| Operation | Who | Rationale |
|-----------|-----|-----------|
| SELECT    | Owner only (wallet_address = JWT sub) | Reminder records are per-user. |
| INSERT / UPDATE / DELETE | Blocked | Written by the `send-deposit-reminders` Edge Function with the service-role key. |

---

## Security test checklist

The following checks should be run from a browser console using only the anon
key to confirm the lockdown is effective:

```js
// Setup: replace with real values
const { createClient } = supabase
const client = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// 1. Read another wallet's email — expect empty rows
await client.from('user_profiles').select('email').neq('wallet_address', MY_WALLET)

// 2. Insert a fake pool_activity row — expect RLS error
await client.from('pool_activity').insert({ pool_id: ANY_POOL_ID, activity_type: 'deposit', user_address: MY_WALLET, amount: 9999 })

// 3. Approve own join_request — expect RLS error (only pool creator can UPDATE)
await client.from('join_requests').update({ status: 'accepted' }).eq('requester_address', MY_WALLET)

// 4. Read another user's notifications — expect empty rows
await client.from('notifications').select('*').neq('wallet_address', MY_WALLET)
```

All four queries should return zero rows or a Postgres RLS error, never data
belonging to another user.
