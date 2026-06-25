import { getAdminClient } from '@/lib/supabase-admin'
import { NextRequest, NextResponse } from 'next/server'

// GET /api/notifications?wallet=<address>
export async function GET(req: NextRequest) {
  const wallet = req.nextUrl.searchParams.get('wallet')?.toLowerCase()
  if (!wallet) return NextResponse.json({ error: 'wallet required' }, { status: 400 })

  const { data, error } = await getAdminClient()
    .from('notifications')
    .select('id, pool_id, activity_type, message, read, created_at')
    .eq('wallet_address', wallet)
    .order('created_at', { ascending: false })
    .limit(10)

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json(data ?? [])
}

// POST /api/notifications  { wallet_address }  — mark all read
export async function POST(req: NextRequest) {
  const { wallet_address } = await req.json()
  if (!wallet_address) return NextResponse.json({ error: 'wallet_address required' }, { status: 400 })

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const { error } = await (getAdminClient() as any)
    .from('notifications')
    .update({ read: true })
    .eq('wallet_address', wallet_address.toLowerCase())
    .eq('read', false)

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })
  return NextResponse.json({ ok: true })
}
