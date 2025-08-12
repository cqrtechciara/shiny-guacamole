/**
 * Login Page
 * Simple placeholder for the login route
 */

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
            Sign in to your account
          </h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            Login page placeholder - Supabase auth integration coming soon
          </p>
        </div>
        <div className="mt-8 space-y-6">
          <div className="rounded-md shadow-sm -space-y-px">
            <p className="text-center text-gray-500 py-8">
              🔐 Login functionality will be implemented with Supabase authentication
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
