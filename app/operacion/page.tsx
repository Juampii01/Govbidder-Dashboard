import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { HubHeader, HubGrid, HubCard } from "@/components/layout/hub"
import { ListTodo, CalendarDays } from "lucide-react"

export const metadata = { title: "Operación" }

export default function OperacionPage() {
  return (
    <DashboardLayout>
      <HubHeader
        title="Operación"
        subtitle="El día a día del equipo: lo que hay que hacer y cuándo."
      />
      <HubGrid>
        <HubCard href="/admin/tasks" icon={ListTodo} color="#3b82f6"
          title="Tareas" desc="Tablero de tareas por departamento: qué está pendiente, en curso y listo." />
        <HubCard href="/calendar" icon={CalendarDays} color="#16a34a"
          title="Agenda" desc="Calendario de sesiones y eventos del equipo." />
      </HubGrid>
    </DashboardLayout>
  )
}
