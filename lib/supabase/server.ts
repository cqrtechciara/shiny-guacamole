import { createServerComponentClient } from '@supabase/auth-helpers-nextjs';
import { cookies } from 'next/headers';
import { Database } from '@/types/database';

/**
 * Create a Supabase client for use in Server Components
 * This client will use cookies for authentication
 */
export const createServerClient = () => {
  const cookieStore = cookies();
  return createServerComponentClient<Database>({ cookies: () => cookieStore });
};

/**
 * Create a Supabase client for use in API routes
 * This is for server-side operations that need authentication
 */
export const createRouteHandlerClient = () => {
  const cookieStore = cookies();
  return createServerComponentClient<Database>({ cookies: () => cookieStore });
};
