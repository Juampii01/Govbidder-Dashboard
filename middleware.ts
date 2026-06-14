import { NextResponse, type NextRequest } from "next/server"
import { createServerClient } from "@supabase/ssr"

/**
 * Middleware de sesión Supabase (patrón oficial @supabase/ssr para App Router).
 *
 * En cada request: lee las cookies de auth, valida/rota el token con
 * supabase.auth.getUser() y vuelve a escribir las cookies actualizadas en la
 * respuesta. Esto mantiene la sesión viva del lado server y permite que las
 * API routes (incluido todo /api/marketing/*) lean la misma sesión que el
 * browser. Sin esto, las routes que dependen de cookies devuelven 401.
 */
export async function middleware(request: NextRequest) {
  let response = NextResponse.next({ request })

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  if (!url || !key) return response

  const supabase = createServerClient(url, key, {
    cookies: {
      getAll: () => request.cookies.getAll(),
      setAll: (cookiesToSet) => {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
        response = NextResponse.next({ request })
        cookiesToSet.forEach(({ name, value, options }) =>
          response.cookies.set(name, value, options)
        )
      },
    },
  })

  // Refresca/valida la sesión y sincroniza cookies. No redirige acá: el gating
  // de auth lo hacen los layouts (DashboardLayout / ContentShell).
  await supabase.auth.getUser()

  return response
}

export const config = {
  // Corre en todo menos assets estáticos.
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico)$).*)",
  ],
}
