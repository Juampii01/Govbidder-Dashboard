import { createBrowserClient } from "@supabase/ssr"

/**
 * Cliente Supabase para el browser.
 *
 * Usa @supabase/ssr (createBrowserClient) que guarda la sesión en COOKIES,
 * no en localStorage. Esto es lo que permite que el server (middleware + API
 * routes, incluido todo /api/marketing/*) lea la misma sesión. La superficie de
 * API es idéntica a supabase-js (auth.signInWithPassword, .from(), etc.), así
 * que ningún caller existente necesita cambios.
 */
export function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!url || !key) {
    throw new Error(
      "Missing NEXT_PUBLIC_SUPABASE_URL or NEXT_PUBLIC_SUPABASE_ANON_KEY in environment."
    )
  }

  return createBrowserClient(url, key)
}
