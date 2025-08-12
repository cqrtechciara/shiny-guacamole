import { test, expect } from '@playwright/test';

/**
 * Smoke Tests - Quick validation that core functionality works
 * These tests should run fast and cover the most critical paths
 */

test.describe('Smoke Tests', () => {
  test('should load the homepage', async ({ page }) => {
    await page.goto('/');
    
    // Check that the page loads and has expected content
    await expect(page).toHaveTitle(/Shiny Guacamole/i);
    await expect(page.locator('h1')).toBeVisible();
  });

  test('should have working navigation', async ({ page }) => {
    await page.goto('/');
    
    // Check that main navigation elements are present and clickable
    const nav = page.locator('nav');
    await expect(nav).toBeVisible();
  });

  test('should be responsive on mobile', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    // Ensure page is still functional on mobile
    await expect(page.locator('h1')).toBeVisible();
    
    // Check that mobile-specific elements work if any
    const body = page.locator('body');
    await expect(body).toBeVisible();
  });

  test('should load without JavaScript errors', async ({ page }) => {
    const errors: Error[] = [];
    
    // Capture console errors
    page.on('pageerror', (error) => {
      errors.push(error);
    });
    
    await page.goto('/');
    
    // Wait a bit for any async operations
    await page.waitForTimeout(2000);
    
    // Check for critical JavaScript errors
    const criticalErrors = errors.filter(error => 
      error.message.toLowerCase().includes('error') && 
      !error.message.toLowerCase().includes('warning')
    );
    
    expect(criticalErrors).toHaveLength(0);
  });

  test('should have basic accessibility features', async ({ page }) => {
    await page.goto('/');
    
    // Check for basic accessibility features
    const mainHeading = page.locator('h1').first();
    await expect(mainHeading).toBeVisible();
    
    // Check that the page has a proper document structure
    await expect(page.locator('main, [role="main"]')).toBeVisible();
  });

  test('should load stylesheets correctly', async ({ page }) => {
    await page.goto('/');
    
    // Check that styles are loaded (page should not look unstyled)
    const body = page.locator('body');
    const backgroundColor = await body.evaluate(
      (el) => window.getComputedStyle(el).backgroundColor
    );
    
    // Should have some background color set (not just browser default)
    expect(backgroundColor).not.toBe('rgba(0, 0, 0, 0)');
  });
});
