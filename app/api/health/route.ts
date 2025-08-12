import { NextRequest, NextResponse } from 'next/server';
import { supabaseAdmin, adminHelpers } from '../lib/supabase-admin';
import os from 'os';

// Use Node.js runtime for access to Node.js APIs (like 'os')
export const runtime = 'nodejs';

// Helper function to check database connectivity
async function checkDatabaseHealth() {
  try {
    // Try to perform a simple query to test DB connectivity
    const { data, error } = await supabaseAdmin
      .from('_health_check')
      .select('1')
      .limit(1)
      .single();
    
    // If table doesn't exist, that's fine - we just want to test connectivity
    if (error && !error.message.includes('does not exist')) {
      return { status: 'unhealthy', error: error.message };
    }
    
    return { status: 'healthy' };
  } catch (error) {
    return { 
      status: 'unhealthy', 
      error: error instanceof Error ? error.message : 'Unknown error'
    };
  }
}

// Helper function to check environment variables
function checkEnvironmentHealth() {
  const requiredEnvVars = [
    'NEXT_PUBLIC_SUPABASE_URL',
    'SUPABASE_SERVICE_ROLE_KEY'
  ];
  
  const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
  
  if (missingVars.length > 0) {
    return {
      status: 'unhealthy',
      error: `Missing environment variables: ${missingVars.join(', ')}`
    };
  }
  
  return { status: 'healthy' };
}

// GET /api/health - Health check endpoint
export async function GET(request: NextRequest) {
  try {
    const startTime = Date.now();
    
    // Check various system components
    const [dbHealth, envHealth] = await Promise.all([
      checkDatabaseHealth(),
      Promise.resolve(checkEnvironmentHealth())
    ]);
    
    const responseTime = Date.now() - startTime;
    const isHealthy = dbHealth.status === 'healthy' && envHealth.status === 'healthy';
    
    const healthData = {
      status: isHealthy ? 'healthy' : 'unhealthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      version: process.env.npm_package_version || 'unknown',
      runtime: {
        type: 'nodejs',
        version: process.version,
        platform: os.platform(),
        arch: os.arch(),
        memory: {
          used: Math.round(process.memoryUsage().rss / 1024 / 1024),
          heapUsed: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
          heapTotal: Math.round(process.memoryUsage().heapTotal / 1024 / 1024)
        }
      },
      checks: {
        database: dbHealth,
        environment: envHealth,
      },
      performance: {
        responseTimeMs: responseTime
      }
    };
    
    return NextResponse.json(
      healthData,
      { 
        status: isHealthy ? 200 : 503,
        headers: {
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0'
        }
      }
    );
  } catch (error) {
    console.error('Health check error:', error);
    
    return NextResponse.json(
      {
        status: 'unhealthy',
        timestamp: new Date().toISOString(),
        error: error instanceof Error ? error.message : 'Unknown error',
        checks: {
          database: { status: 'error', error: 'Health check failed' },
          environment: { status: 'error', error: 'Health check failed' }
        }
      },
      { status: 503 }
    );
  }
}

// HEAD /api/health - Lightweight health check for load balancers
export async function HEAD(request: NextRequest) {
  try {
    // Quick database connectivity test
    const dbHealth = await checkDatabaseHealth();
    const envHealth = checkEnvironmentHealth();
    
    const isHealthy = dbHealth.status === 'healthy' && envHealth.status === 'healthy';
    
    return new NextResponse(null, {
      status: isHealthy ? 200 : 503,
      headers: {
        'Cache-Control': 'no-cache, no-store, must-revalidate'
      }
    });
  } catch (error) {
    return new NextResponse(null, { status: 503 });
  }
}
