/**
 * Dashboard Page
 * Simple placeholder for the dashboard route
 */

export default function DashboardPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="py-10">
          <header>
            <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
              <h1 className="text-3xl font-bold leading-tight tracking-tight text-gray-900">
                Dashboard
              </h1>
            </div>
          </header>
          <main>
            <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
              <div className="px-4 py-8 sm:px-0">
                <div className="rounded-lg border-4 border-dashed border-gray-200 p-8">
                  <div className="text-center">
                    <h2 className="text-xl font-semibold text-gray-900 mb-4">
                      Welcome to your Dashboard
                    </h2>
                    <p className="text-gray-600 mb-6">
                      Dashboard placeholder - Supabase integration and user data coming soon
                    </p>
                    <div className="bg-blue-50 p-6 rounded-lg">
                      <p className="text-blue-700">
                        📊 This dashboard will display user-specific data from Supabase
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </main>
        </div>
      </div>
    </div>
  );
}
