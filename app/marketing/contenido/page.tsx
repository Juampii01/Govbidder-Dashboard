import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { ContenidoContent } from "@/components/marketing/contenido/ContenidoContent"
export const metadata = { title: "Estudio de Contenido" }
export default function ContenidoPage() {
  return <DashboardLayout><ContenidoContent /></DashboardLayout>
}
