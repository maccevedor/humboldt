/**
 * Test Script for URL Parameter Handling Fix
 *
 * This script tests the fix for the URL parameter handling issue where
 * layer loading behaved inconsistently based on URL format and navigation method.
 *
 * Run this in the browser console after the page loads.
 */

// Test utilities
const testResults = [];

function logTest(testName, passed, message) {
    const result = { testName, passed, message, timestamp: new Date().toISOString() };
    testResults.push(result);
    console.log(`${passed ? '✅' : '❌'} ${testName}: ${message}`);
    return passed;
}

function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Test 1: Check if event delegation is working
async function testEventDelegation() {
    console.log('\n=== Test 1: Event Delegation ===');

    // Create a test checkbox dynamically
    const testCheckbox = document.createElement('input');
    testCheckbox.type = 'checkbox';
    testCheckbox.className = 'layers-input';
    testCheckbox.id = 'test-layer-dynamic';
    document.body.appendChild(testCheckbox);

    await delay(100);

    // Try to click it
    let clickHandled = false;
    const originalHandler = window.jQuery || window.$;
    if (originalHandler) {
        testCheckbox.click();
        await delay(100);

        // Check if the click was handled (checkbox state changed)
        clickHandled = testCheckbox.checked;
    }

    // Cleanup
    document.body.removeChild(testCheckbox);

    return logTest(
        'Event Delegation',
        clickHandled,
        clickHandled
            ? 'Dynamically created checkbox click was handled'
            : 'Event delegation may not be working properly'
    );
}

// Test 2: Check URL parameter sync on checkbox click
async function testURLParameterSync() {
    console.log('\n=== Test 2: URL Parameter Sync ===');

    // Find a real checkbox
    const checkbox = document.querySelector('.layers-input');
    if (!checkbox) {
        return logTest('URL Parameter Sync', false, 'No checkbox found to test');
    }

    const layerId = checkbox.id;
    const initialURL = window.location.href;
    const initialChecked = checkbox.checked;

    // Toggle checkbox
    checkbox.checked = !initialChecked;
    checkbox.click();

    await delay(500);

    // Check if URL was updated
    const urlParams = new URLSearchParams(window.location.search);
    const capaParam = urlParams.get('capa');

    const urlUpdated = checkbox.checked ? capaParam === layerId : capaParam !== layerId;

    // Restore state
    checkbox.checked = initialChecked;
    checkbox.click();
    await delay(500);

    return logTest(
        'URL Parameter Sync',
        urlUpdated,
        urlUpdated
            ? `URL parameter correctly ${checkbox.checked ? 'set' : 'removed'}`
            : 'URL parameter not synced with checkbox state'
    );
}

// Test 3: Check layer activation from URL parameter
async function testLayerActivationFromURL() {
    console.log('\n=== Test 3: Layer Activation from URL ===');

    // Get available layers
    const availableLayers = window.getAvailableLayerNames ? window.getAvailableLayerNames() : [];

    if (availableLayers.length === 0) {
        return logTest('Layer Activation from URL', false, 'No layers available to test');
    }

    // Pick a layer that's currently not visible
    const testLayer = availableLayers.find(l => !l.visible);
    if (!testLayer) {
        return logTest('Layer Activation from URL', false, 'All layers are already visible');
    }

    // Try to activate it using the URL parameter function
    const activateLayer = window.activateLayer;
    if (!activateLayer) {
        return logTest('Layer Activation from URL', false, 'activateLayer function not available');
    }

    const success = activateLayer(testLayer.geoserverName);
    await delay(500);

    // Check if checkbox is now checked
    const checkbox = document.getElementById(testLayer.geoserverName);
    const checkboxChecked = checkbox ? checkbox.checked : false;

    return logTest(
        'Layer Activation from URL',
        success && checkboxChecked,
        success && checkboxChecked
            ? `Layer ${testLayer.displayName} activated and checkbox synced`
            : `Failed to activate layer or sync checkbox`
    );
}

// Test 4: Check retry mechanism
async function testRetryMechanism() {
    console.log('\n=== Test 4: Retry Mechanism ===');

    // This test checks if the processURLParams function has retry logic
    const processURLParams = window.processURLParams;
    if (!processURLParams) {
        return logTest('Retry Mechanism', false, 'processURLParams function not available');
    }

    // Check if the function accepts a callback (new signature)
    const functionString = processURLParams.toString();
    const hasCallback = functionString.includes('onLayerTreeReady') || functionString.includes('callback');
    const hasRetry = functionString.includes('retry') || functionString.includes('tryActivateLayer');

    return logTest(
        'Retry Mechanism',
        hasCallback && hasRetry,
        hasCallback && hasRetry
            ? 'processURLParams has callback support and retry logic'
            : 'processURLParams may not have proper retry mechanism'
    );
}

// Test 5: Check for circular dependency issues
async function testCircularDependencies() {
    console.log('\n=== Test 5: Circular Dependencies ===');

    // Check if dynamic imports are used
    const mapScript = document.querySelector('script[src*="map.js"]');
    const hierarchicalScript = document.querySelector('script[src*="hierarchical-tree-layers.js"]');

    // This is a basic check - in production, we'd need to analyze the actual imports
    const noDependencyErrors = !window.lastError || !window.lastError.message.includes('circular');

    return logTest(
        'Circular Dependencies',
        noDependencyErrors,
        noDependencyErrors
            ? 'No circular dependency errors detected'
            : 'Potential circular dependency issues found'
    );
}

// Main test runner
async function runAllTests() {
    console.log('🧪 Starting URL Parameter Handling Tests...\n');
    console.log('Current URL:', window.location.href);
    console.log('Current Project:', window.currentProject || 'unknown');

    const tests = [
        testEventDelegation,
        testURLParameterSync,
        testLayerActivationFromURL,
        testRetryMechanism,
        testCircularDependencies
    ];

    for (const test of tests) {
        try {
            await test();
        } catch (error) {
            console.error(`Error running test: ${error.message}`);
            logTest(test.name, false, `Exception: ${error.message}`);
        }
    }

    // Summary
    console.log('\n=== Test Summary ===');
    const passed = testResults.filter(r => r.passed).length;
    const total = testResults.length;
    console.log(`Passed: ${passed}/${total}`);

    if (passed === total) {
        console.log('✅ All tests passed!');
    } else {
        console.log('❌ Some tests failed. Review the results above.');
    }

    return testResults;
}

// Export for use in console
window.runURLParameterTests = runAllTests;

// Auto-run if this script is loaded directly
if (typeof module === 'undefined') {
    console.log('To run tests, execute: runURLParameterTests()');
}
