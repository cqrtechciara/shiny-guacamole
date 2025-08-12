import { NextRequest, NextResponse } from 'next/server';
import { adminHelpers } from '../lib/supabase-admin';
import { z } from 'zod';

// Enable Edge Runtime for better performance
export const runtime = 'edge';

// Input validation schemas
const createUserSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  userData: z.record(z.any()).optional(),
});

const updateUserSchema = z.object({
  email: z.string().email().optional(),
  password: z.string().min(8).optional(),
  user_metadata: z.record(z.any()).optional(),
  app_metadata: z.record(z.any()).optional(),
});

// Helper function for error responses
function errorResponse(message: string, status = 400) {
  return NextResponse.json(
    { error: message },
    { status }
  );
}

// Helper function for success responses
function successResponse(data: any, status = 200) {
  return NextResponse.json(data, { status });
}

// GET /api/users - List all users with pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const perPage = Math.min(parseInt(searchParams.get('per_page') || '10'), 100);

    if (page < 1 || perPage < 1) {
      return errorResponse('Invalid pagination parameters');
    }

    const { users, error } = await adminHelpers.getAllUsers(page, perPage);

    if (error) {
      console.error('Error fetching users:', error);
      return errorResponse('Failed to fetch users', 500);
    }

    return successResponse({
      users: users?.map(user => ({
        id: user.id,
        email: user.email,
        created_at: user.created_at,
        last_sign_in_at: user.last_sign_in_at,
        user_metadata: user.user_metadata,
        app_metadata: user.app_metadata,
      })) || [],
      pagination: {
        page,
        per_page: perPage,
        total: users?.length || 0,
      },
    });
  } catch (error) {
    console.error('Unexpected error in GET /api/users:', error);
    return errorResponse('Internal server error', 500);
  }
}

// POST /api/users - Create a new user
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate input
    const validationResult = createUserSchema.safeParse(body);
    if (!validationResult.success) {
      return errorResponse(
        `Validation error: ${validationResult.error.errors.map(e => e.message).join(', ')}`
      );
    }

    const { email, password, userData } = validationResult.data;

    const { user, error } = await adminHelpers.createUser(
      email,
      password,
      userData
    );

    if (error) {
      console.error('Error creating user:', error);
      if (error.message.includes('already registered')) {
        return errorResponse('User with this email already exists', 409);
      }
      return errorResponse('Failed to create user', 500);
    }

    return successResponse(
      {
        message: 'User created successfully',
        user: {
          id: user?.id,
          email: user?.email,
          created_at: user?.created_at,
        },
      },
      201
    );
  } catch (error) {
    console.error('Unexpected error in POST /api/users:', error);
    return errorResponse('Internal server error', 500);
  }
}

// PUT /api/users - Update user (expects user ID in query params)
export async function PUT(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('id');

    if (!userId) {
      return errorResponse('User ID is required');
    }

    const body = await request.json();
    
    // Validate input
    const validationResult = updateUserSchema.safeParse(body);
    if (!validationResult.success) {
      return errorResponse(
        `Validation error: ${validationResult.error.errors.map(e => e.message).join(', ')}`
      );
    }

    const updates = validationResult.data;
    const { user, error } = await adminHelpers.updateUser(userId, updates);

    if (error) {
      console.error('Error updating user:', error);
      if (error.message.includes('not found')) {
        return errorResponse('User not found', 404);
      }
      return errorResponse('Failed to update user', 500);
    }

    return successResponse({
      message: 'User updated successfully',
      user: {
        id: user?.id,
        email: user?.email,
        updated_at: user?.updated_at,
      },
    });
  } catch (error) {
    console.error('Unexpected error in PUT /api/users:', error);
    return errorResponse('Internal server error', 500);
  }
}

// DELETE /api/users - Delete a user (expects user ID in query params)
export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('id');

    if (!userId) {
      return errorResponse('User ID is required');
    }

    const { user, error } = await adminHelpers.deleteUser(userId);

    if (error) {
      console.error('Error deleting user:', error);
      if (error.message.includes('not found')) {
        return errorResponse('User not found', 404);
      }
      return errorResponse('Failed to delete user', 500);
    }

    return successResponse({
      message: 'User deleted successfully',
      deleted_user_id: userId,
    });
  } catch (error) {
    console.error('Unexpected error in DELETE /api/users:', error);
    return errorResponse('Internal server error', 500);
  }
}

// OPTIONS handler for CORS preflight requests
export async function OPTIONS() {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Max-Age': '86400',
    },
  });
}
