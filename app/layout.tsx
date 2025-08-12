import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Shiny Guacamole",
  description: "A Next.js 14 TypeScript application with Tailwind CSS",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}
