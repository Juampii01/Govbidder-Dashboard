import { DashboardLayout } from "@/components/layout/dashboard-layout"
import { IGProPage } from "@/components/marketing/instagram/IGProPage"
export const metadata = { title: "Instagram" }
export default function InstagramPage() {
  return <DashboardLayout><IGProPage /></DashboardLayout>
}
