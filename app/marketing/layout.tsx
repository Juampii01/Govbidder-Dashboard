import { ContentShell } from "@/components/marketing/content-shell"

export const metadata = { title: "Content Dashboard" }

export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  return <ContentShell>{children}</ContentShell>
}
