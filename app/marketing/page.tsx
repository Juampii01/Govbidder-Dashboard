import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { MarketingKPIsView } from "@/components/views/marketing-kpis-view"

export const metadata = { title: "Marketing" }

export default function MarketingPage() {
  return (
    <DashboardLayout>
      <MarketingKPIsView />
    </DashboardLayout>
  )
}
