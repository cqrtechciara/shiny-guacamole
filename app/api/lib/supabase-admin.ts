import { createClient } from '@supabase/supabase-js';

// Environment variables validation
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl) {
  throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL environment variable');
}

if (!supabaseServiceRoleKey) {
  throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY environment variable');
}

// Create Supabase admin client with service role key
// This bypasses Row Level Security and should only be used server-side
export const supabaseAdmin = createClient(supabaseUrl, supabaseServiceRoleKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false,
  },
});

// Helper functions for common admin operations
export const adminHelpers = {
  // Get user by ID (bypassing RLS)
  async getUserById(userId: string) {
    const { data, error } = await supabaseAdmin.auth.admin.getUserById(userId);
    return { user: data.user, error };
  },

  // List all users with pagination
  async getAllUsers(page = 1, perPage = 1000) {
    const { data, error } = await supabaseAdmin.auth.admin.listUsers({
      page,
      perPage,
    });
    return { users: data.users, error };
  },

  // Create a new user
  async createUser(email: string, password: string, userData?: Record<string, any>) {
    const { data, error } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: userData,
    });
    return { user: data.user, error };
  },

  // Update user metadata
  async updateUser(userId: string, updates: {
    email?: string;
    password?: string;
    user_metadata?: Record<string, any>;
    app_metadata?: Record<string, any>;
  }) {
    const { data, error } = await supabaseAdmin.auth.admin.updateUserById(
      userId,
      updates
    );
    return { user: data.user, error };
  },

  // Delete a user
  async deleteUser(userId: string) {
    const { data, error } = await supabaseAdmin.auth.admin.deleteUser(userId);
    return { user: data.user, error };
  },

  // Execute raw SQL query (use with caution)
  async executeQuery(query: string, params: any[] = []) {
    const { data, error } = await supabaseAdmin.rpc('execute_sql', {
      query,
      params,
    });
    return { data, error };
  },

  // Get database stats
  async getDatabaseStats() {
    const { data, error } = await supabaseAdmin.rpc('get_db_stats');
    return { stats: data, error };
  },
};

// Type definitions for better TypeScript support
export type Database = {
  // Define your database schema here
  // Example:
  // public: {
  //   Tables: {
  //     users: {
  //       Row: {
  //         id: string;
  //         email: string;
  //         created_at: string;
  //       };
  //       Insert: {
  //         email: string;
  //       };
  //       Update: {
  //         email?: string;
  //       };
  //     };
  //   };
  // };
};

// Export typed client for specific use cases
export const typedSupabaseAdmin = supabaseAdmin as ReturnType<
  typeof createClient<Database>
>;
