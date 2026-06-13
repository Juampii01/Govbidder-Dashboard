import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { ContenidoView } from "@/components/views/marketing-view"

export const metadata = { title: "Contenido" }

export default function ContenidoPage() {
  return (
    <DashboardLayout>
      <ContenidoView />
    </DashboardLayout>
  )
}
