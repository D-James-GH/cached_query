/// Base URL for the examples mock API server.
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// Fixed artificial delay used by the cancellation demo.
const cancelDemoDelayMs = 5000;
