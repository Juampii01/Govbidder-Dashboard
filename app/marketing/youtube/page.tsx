import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { YTProPage } from "@/components/marketing/youtube/YTProPage"
export const metadata = { title: "YouTube" }
export default function YouTubePage() {
  return <DashboardLayout><YTProPage /></DashboardLayout>
}
