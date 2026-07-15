/**
 * Auth compartido para API routes.
 *
 * Las rutas de /api (fuera de /api/marketing) reciben el JWT en el header
 * Authorization y usan el service client (bypasea RLS) para la data. Eso
 * significa que el check de authz de cada route es LA única defensa — el
 * middleware no gatea y RLS no aplica. Usar siempre estos helpers en vez de
 * copy-pastear getUser() por route.
 *
 * Uso:
 *   const auth = await requireAdmin(req)          // 401 / 403 automáticos
 *   if ("fail" in auth) return auth.fail
 *   const { caller } = auth
 *
 *   const auth = await requireUser(req)           // solo autenticación
 *   if ("fail" in auth) return auth.fail
 *   if (!isAdminOrAbove(auth.caller.role)) { ...scoping propio... }
 */

import { NextRequest, NextResponse } from "next/server"
import type { User } from "@supabase/supabase-js"
import { createClient } from "@/lib/supabase"
import { createServiceClient } from "@/lib/supabase-service"
import { isAdminOrAbove, type Role } from "@/lib/types/role"

export interface Caller {
  user: User
  role: Role
  departmentId: string | null
}

/** Resuelve el caller (user + rol + depto) desde el Bearer token. */
export async function getCaller(req: NextRequest): Promise<Caller | null> {
  const token = req.headers.get("authorization")?.replace("Bearer ", "")
  if (!token) return null

  const { data: { user } } = await createClient().auth.getUser(token)
  if (!user) return null

  const db = createServiceClient()
  const { data: profile } = await db
    .from("profiles")
    .select("role, department_id")
    .eq("id", user.id)
    .single()

  return {
    user,
    role: (profile?.role as Role | undefined) ?? "user",
    departmentId: (profile?.department_id as string | null) ?? null,
  }
}

type AuthResult = { caller: Caller } | { fail: NextResponse }

/** 401 si no hay sesión válida. */
export async function requireUser(req: NextRequest): Promise<AuthResult> {
  const caller = await getCaller(req)
  if (!caller) {
    return { fail: NextResponse.json({ error: "No autorizado" }, { status: 401 }) }
  }
  return { caller }
}

/** 401 si no hay sesión, 403 si el rol no es admin o superior. */
export async function requireAdmin(req: NextRequest): Promise<AuthResult> {
  const auth = await requireUser(req)
  if ("fail" in auth) return auth
  if (!isAdminOrAbove(auth.caller.role)) {
    return { fail: NextResponse.json({ error: "Requiere rol admin" }, { status: 403 }) }
  }
  return auth
}

/**
 * Filtra un body de PATCH a la whitelist de columnas editables.
 * Evita mass assignment (setear created_by, timestamps, etc. desde el cliente).
 */
export function pickAllowed<T extends Record<string, unknown>>(
  body: T,
  allowed: readonly string[],
): Record<string, unknown> {
  const out: Record<string, unknown> = {}
  for (const key of allowed) {
    if (key in body) out[key] = body[key]
  }
  return out
}
