// This file configures the initialization of Sentry on the server side.
// The config you add here will be used whenever the server handles a request.
// https://docs.sentry.io/platforms/javascript/guides/nextjs/

import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  
  // Define how likely traces are sampled. Adjust this value in production, or use tracesSampler for greater control.
  tracesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,
  
  // Setting this option to true will print useful information to the console while you're setting up Sentry.
  debug: process.env.NODE_ENV === "development",
  
  environment: process.env.NODE_ENV,
  
  // Performance monitoring
  integrations: [
    // Enable profiling
    Sentry.profilingIntegration(),
  ],
  
  // Capture 100% of the transactions for performance monitoring in development,
  // but only 10% in production
  profilesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,
  
  // Privacy-focused configuration
  beforeSend(event) {
    // Filter out sensitive data from server-side events
    if (event.exception) {
      const error = event.exception.values?.[0];
      if (error?.value?.includes('password') || 
          error?.value?.includes('token') || 
          error?.value?.includes('key') || 
          error?.value?.includes('secret')) {
        return null; // Don't send events containing sensitive data
      }
    }
    
    // Remove sensitive request data
    if (event.request) {
      // Remove sensitive headers
      if (event.request.headers) {
        delete event.request.headers['authorization'];
        delete event.request.headers['cookie'];
        delete event.request.headers['x-api-key'];
      }
      
      // Remove sensitive query parameters
      if (event.request.query_string) {
        event.request.query_string = event.request.query_string
          ?.replace(/([?&])(password|token|key|secret)=[^&]*/gi, '$1$2=***');
      }
    }
    
    return event;
  },
});
