import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Shiny Guacamole",
  description: "A Next.js 14 TypeScript Mobile website with Tailwind CSS",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased min-h-screen bg-background font-sans">
        <div className="flex min-h-screen flex-col">
          <header className="border-b bg-white/95 backdrop-blur supports-[backdrop-filter]:bg-white/60">
            <div className="container flex h-14 items-center">
              <nav className="flex items-center space-x-6 text-sm font-medium">
                <a
                  href="/"
                  className="transition-colors hover:text-foreground/80 text-foreground/60"
                >
                  Home
                </a>
                <a
                  href="/dashboard"
                  className="transition-colors hover:text-foreground/80 text-foreground/60"
                >
                  Dashboard
                </a>
              </nav>
              <div className="flex flex-1 items-center justify-end space-x-4">
                <nav className="flex items-center space-x-2">
                  <a
                    href="/login"
                    className="inline-flex items-center justify-center rounded-md text-sm font-medium transition-colors h-9 px-4 py-2 bg-primary text-primary-foreground hover:bg-primary/90"
                  >
                    Sign In
                  </a>
                </nav>
              </div>
            </div>
          </header>
          <main className="flex-1">
            <div className="container mx-auto py-6">
              {children}
            </div>
          </main>
          <footer className="border-t py-6 md:py-0">
            <div className="container flex flex-col items-center justify-between gap-4 md:h-24 md:flex-row">
              <p className="text-center text-sm leading-loose text-muted-foreground md:text-left">
                Built with Next.js, TypeScript, and Tailwind CSS.
              </p>
            </div>
          </footer>
        </div>
      </body>
    </html>
  );
}
