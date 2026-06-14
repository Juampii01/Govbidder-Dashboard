/**
 * auth-user shim — adapta la interfaz del Content Dashboard al auth de GovBidder.
 * El Content Dashboard usa cookies SSR (@supabase/ssr), acá usamos el service client.
 */
import { cookies } from 'next/headers'
import { createServerClient } from '@supabase/ssr'
import { db } from './db'
import { ACTIVE_BRAND_COOKIE, DEFAULT_BRAND_ID, isValidBrandId } from './brands'

export class UnauthorizedError extends Error {
  constructor(msg = 'No autorizado') { super(msg); this.name = 'UnauthorizedError' }
}
export class ForbiddenError extends Error {
  constructor(msg = 'Sin acceso') { super(msg); this.name = 'ForbiddenError' }
}

export async function getUserIdOrNull(): Promise<string | null> {
  const cookieStore = await cookies()
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    { cookies: { getAll: () => cookieStore.getAll(), setAll: () => {} } }
  )
  // getUser() valida el JWT contra el server de auth (más seguro que getSession,
  // que solo decodifica el token local). El middleware ya refrescó la cookie.
  const { data: { user } } = await supabase.auth.getUser()
  return user?.id ?? null
}

export async function requireUserId(): Promise<string> {
  const id = await getUserIdOrNull()
  if (!id) throw new UnauthorizedError()
  return id
}

export async function getActiveClientId(): Promise<string | null> {
  const userId = await getUserIdOrNull()
  if (!userId) return null
  // La marca activa es compartida por el equipo y se elige con el selector
  // (cookie). No depende de Profile.clientId. Default = marca principal.
  const cookieStore = await cookies()
  const selected = cookieStore.get(ACTIVE_BRAND_COOKIE)?.value
  return isValidBrandId(selected) ? selected : DEFAULT_BRAND_ID
}

export async function requireActiveClient(): Promise<{ userId: string; clientId: string }> {
  const userId = await requireUserId()
  const clientId = await getActiveClientId()
  if (!clientId) throw new ForbiddenError('Sin workspace asignado')
  return { userId, clientId }
}

export async function requireProfile() {
  const userId = await requireUserId()
  const profile = await db.profile.findUnique({ where: { id: userId } })
  if (!profile) throw new ForbiddenError('Perfil no encontrado')
  return profile
}
