import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { PerformanceView } from "@/components/views/performance-view"

export const metadata = { title: "Performance" }

export default async function PerformancePage({
  searchParams,
}: {
  searchParams: Promise<{ tab?: string }>
}) {
  const { tab } = await searchParams
  return (
    <DashboardLayout>
      <PerformanceView initialTab={tab ?? "panel"} />
    </DashboardLayout>
  )
}
