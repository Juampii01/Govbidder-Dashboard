import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { AnalizadorContent } from "@/components/marketing/analizador/AnalizadorContent"
export const metadata = { title: "Analizador de Reels" }
export default function AnalizadorPage() {
  return <DashboardLayout><AnalizadorContent /></DashboardLayout>
}
