import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { HubHeader, HubGrid, HubCard } from "@/components/layout/hub"
import { BarChart3, DollarSign, LayoutGrid, Users2, FileBarChart } from "lucide-react"

export const metadata = { title: "Performance" }

export default function PerformancePage() {
  return (
    <DashboardLayout>
      <HubHeader
        title="Performance"
        subtitle="Todo el rendimiento del negocio en un solo lugar. Elegí qué querés ver."
      />
      <HubGrid>
        <HubCard href="/dashboard" icon={BarChart3} color="#1e3a8a"
          title="Panel general" desc="Resumen ejecutivo: KPIs del mes, tendencias y salud del negocio." />
        <HubCard href="/sales" icon={DollarSign} color="#16a34a"
          title="Ventas" desc="Llamadas agendadas y atendidas, nuevos clientes cerrados, números del mes." />
        <HubCard href="/admin/personas" icon={Users2} color="#0ea5e9"
          title="Personas agendadas" desc="Pipeline de personas: agendadas, atendidas y seguimiento." />
        <HubCard href="/metrics" icon={LayoutGrid} color="#7c3aed"
          title="Métricas detalladas" desc="Todas las métricas: comparativas mes a mes y evolución histórica." />
        <HubCard href="/admin/reports" icon={FileBarChart} color="#ea580c"
          title="Cargar reporte" desc="Subí los números del mes para alimentar los paneles." />
      </HubGrid>
    </DashboardLayout>
  )
}
