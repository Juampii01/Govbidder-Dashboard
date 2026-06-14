import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { KanbanBoard } from "@/components/marketing/tareas/KanbanBoard"
export const metadata = { title: "Tareas Contenido" }
export default function TareasPage() {
  return <DashboardLayout><KanbanBoard /></DashboardLayout>
}
