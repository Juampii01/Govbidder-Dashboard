import { redirect } from "next/navigation"

// Puerta única de Content: el hub real vive en /marketing (KPIs nativos +
// sub-secciones). El viejo iframe al Content Dashboard externo confundía:
// dos entradas distintas para "contenido".
export default function ContenidoPage() {
  redirect("/marketing")
}
