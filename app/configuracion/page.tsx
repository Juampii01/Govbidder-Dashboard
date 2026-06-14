import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { HubHeader, HubSection, HubCard } from "@/components/layout/hub"
import {
  Users, Layers, Rss, LayoutTemplate, FormInput, Wrench, BookOpen,
} from "lucide-react"

export const metadata = { title: "Configuración" }

export default function ConfiguracionPage() {
  return (
    <DashboardLayout>
      <HubHeader
        title="Configuración"
        subtitle="Equipo, plantillas, recursos y herramientas internas."
      />

      <HubSection label="Equipo">
        <HubCard href="/admin/team" icon={Users} color="#1e3a8a"
          title="Miembros" desc="Personas del equipo, roles y accesos." />
        <HubCard href="/admin/departments" icon={Layers} color="#7c3aed"
          title="Departamentos" desc="Áreas del negocio y su organización." />
        <HubCard href="/admin/activity" icon={Rss} color="#0ea5e9"
          title="Actividad" desc="Registro de lo que hace el equipo en tiempo real." />
      </HubSection>

      <HubSection label="Sistema">
        <HubCard href="/admin/task-templates" icon={LayoutTemplate} color="#ea580c"
          title="Plantillas" desc="Templates de tareas reutilizables." />
        <HubCard href="/admin/forms" icon={FormInput} color="#16a34a"
          title="Formularios" desc="Forms públicos para captar datos." />
        <HubCard href="/admin/centro-operativo" icon={Layers} color="#0891b2"
          title="Centro Operativo" desc="Configuración operativa central." />
        <HubCard href="/tools" icon={Wrench} color="#64748b"
          title="Herramientas" desc="Utilidades internas (research de contenido, etc.)." />
        <HubCard href="/recursos" icon={BookOpen} color="#9333ea"
          title="Biblioteca" desc="Recursos y documentación del equipo." />
      </HubSection>
    </DashboardLayout>
  )
}
