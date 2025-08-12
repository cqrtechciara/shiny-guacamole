import { createClientComponentClient } from '@supabase/auth-helpers-nextjs';
import { Database } from '@/types/database';

/**
 * Create a Supabase client for use in Client Components
 * This client will automatically handle authentication state
 */
export const createClient = () => {
  return createClientComponentClient<Database>();
};

// Export the client instance for convenience
export const supabase = createClient();
