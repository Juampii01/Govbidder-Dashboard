import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { TTProPage } from "@/components/marketing/tiktok/TTProPage"
export const metadata = { title: "TikTok" }
export default function TikTokPage() {
  return <DashboardLayout><TTProPage /></DashboardLayout>
}
