/**
 * Marcas (workspaces) del Content Dashboard.
 *
 * Cada marca es un `Client` con su propio set de cuentas conectadas (IG/YT/etc)
 * y sus propios datos de analytics (las tablas se llavean por clientId). El
 * equipo comparte estas marcas: el selector cambia la marca ACTIVA para todos,
 * no es por-usuario. La marca activa se guarda en una cookie.
 *
 * Para agregar/renombrar marcas: editá BRANDS acá y creá el `Client` en la DB
 * con el mismo `id` (ver scripts/SQL de seed de marcas).
 */

export const BRANDS = [
  { id: "brand-santo",  name: "Santo",   slug: "santo"   },
  { id: "brand-tiosam", name: "Tío Sam", slug: "tio-sam" },
] as const

export type Brand = (typeof BRANDS)[number]
export type BrandId = Brand["id"]

/** Marca por defecto (principal) cuando no hay selección. */
export const DEFAULT_BRAND_ID: BrandId = "brand-santo"

/** Cookie que guarda la marca activa. */
export const ACTIVE_BRAND_COOKIE = "active_brand"

export function isValidBrandId(id: string | null | undefined): id is BrandId {
  return !!id && BRANDS.some((b) => b.id === id)
}

export function brandName(id: string | null | undefined): string {
  return BRANDS.find((b) => b.id === id)?.name ?? "—"
}
