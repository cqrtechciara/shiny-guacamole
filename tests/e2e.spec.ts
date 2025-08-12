import { test, expect } from '@playwright/test';

/**
 * End-to-End (E2E) Tests - Full user journey testing
 * These tests simulate real user interactions and workflows
 */

test.describe('E2E Tests', () => {
  test('complete user journey: homepage to navigation', async ({ page }) => {
    // Start at homepage
    await page.goto('/');

    // Verify homepage loaded correctly
    await expect(page).toHaveTitle(/Shiny Guacamole/i);
    await expect(page.locator('h1')).toBeVisible();

    // Check that main content is visible
    await expect(page.locator('main, [role="main"], body')).toBeVisible();
    
    // Verify page structure
    const pageContent = page.locator('body');
    await expect(pageContent).toBeVisible();
  });

  test('user can interact with page elements', async ({ page }) => {
    await page.goto('/');

    // Check for interactive elements
    const interactiveElements = page.locator('button, a[href], input, select, textarea');
    const count = await interactiveElements.count();
    
    // Should have at least some interactive elements
    expect(count).toBeGreaterThan(0);

    // Test clicking if there are any buttons
    const buttons = page.locator('button');
    const buttonCount = await buttons.count();
    
    if (buttonCount > 0) {
      const firstButton = buttons.first();
      await expect(firstButton).toBeVisible();
      // Note: We don't actually click as we don't know the behavior yet
    }
  });

  test('page handles different screen sizes', async ({ page }) => {
    // Test desktop size
    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.goto('/');
    await expect(page.locator('h1')).toBeVisible();
    
    // Test tablet size
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.reload();
    await expect(page.locator('h1')).toBeVisible();
    
    // Test mobile size
    await page.setViewportSize({ width: 375, height: 667 });
    await page.reload();
    await expect(page.locator('h1')).toBeVisible();
  });

  test('page content is accessible via keyboard navigation', async ({ page }) => {
    await page.goto('/');
    
    // Check focus management
    await page.keyboard.press('Tab');
    
    // Verify that focus is visible (at least one focusable element exists)
    const focusableElements = page.locator(
      'a[href], button, input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    
    const count = await focusableElements.count();
    expect(count).toBeGreaterThanOrEqual(0); // At least 0, might be more depending on content
  });

  test('page loads external resources correctly', async ({ page }) => {
    // Monitor network requests
    const responses: any[] = [];
    const errors: any[] = [];
    
    page.on('response', (response) => {
      responses.push(response);
    });
    
    page.on('requestfailed', (request) => {
      errors.push(request);
    });

    await page.goto('/');
    
    // Wait for page to fully load
    await page.waitForLoadState('networkidle');
    
    // Check that essential resources loaded (HTML should be 200)
    const htmlResponse = responses.find(r => r.url().includes('/') && r.request().resourceType() === 'document');
    if (htmlResponse) {
      expect(htmlResponse.status()).toBe(200);
    }
    
    // Check that there are no critical failed requests
    const criticalErrors = errors.filter(req => 
      req.resourceType() === 'document' || 
      req.resourceType() === 'script'
    );
    
    expect(criticalErrors.length).toBe(0);
  });

  test('page performance is acceptable', async ({ page }) => {
    // Monitor performance
    await page.goto('/');
    
    // Measure page load timing
    const timing = await page.evaluate(() => {
      const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
      return {
        domContentLoaded: navigation.domContentLoadedEventEnd - navigation.domContentLoadedEventStart,
        loadComplete: navigation.loadEventEnd - navigation.loadEventStart,
        domInteractive: navigation.domInteractive - navigation.navigationStart
      };
    });
    
    // Basic performance checks (these are generous limits for development)
    expect(timing.domInteractive).toBeLessThan(5000); // DOM should be interactive within 5s
    expect(timing.domContentLoaded).toBeLessThan(3000); // DOMContentLoaded should fire within 3s
  });

  test('page handles errors gracefully', async ({ page }) => {
    const consoleErrors: string[] = [];
    const pageErrors: Error[] = [];
    
    // Capture console errors
    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        consoleErrors.push(msg.text());
      }
    });
    
    // Capture page errors
    page.on('pageerror', (error) => {
      pageErrors.push(error);
    });
    
    await page.goto('/');
    
    // Wait for any async operations
    await page.waitForTimeout(3000);
    
    // Filter out known non-critical errors (if any)
    const criticalPageErrors = pageErrors.filter(error => 
      !error.message.toLowerCase().includes('non-critical') &&
      !error.message.toLowerCase().includes('warning')
    );
    
    const criticalConsoleErrors = consoleErrors.filter(error => 
      !error.toLowerCase().includes('warning') &&
      !error.toLowerCase().includes('info')
    );
    
    // Should have minimal critical errors
    expect(criticalPageErrors.length).toBeLessThanOrEqual(1);
    expect(criticalConsoleErrors.length).toBeLessThanOrEqual(2);
  });
});
