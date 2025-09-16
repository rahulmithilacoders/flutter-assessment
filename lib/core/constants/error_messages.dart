class ErrorMessages {
  // Health Connect Error Messages
  static const String healthConnectNotInstalled = 'Health Connect app is not installed on this device';
  static const String permissionsRequired = 'Health data permissions are required to track steps';
  static const String dataNotAvailable = 'Health data is not available at this time';
  static const String networkError = 'Network error occurred while accessing health data';
  static const String unknownError = 'An unexpected error occurred while accessing health data';
  
  // Error Titles
  static const String healthConnectRequiredTitle = 'Health Connect Required';
  static const String permissionRequiredTitle = 'Permission Required';
  static const String dataUnavailableTitle = 'Data Unavailable';
  static const String connectionErrorTitle = 'Connection Error';
  static const String errorTitle = 'Error';
  
  // Error Solutions
  static const String installHealthConnectSolution = 'Please install Health Connect from the Play Store to track your steps.';
  static const String grantPermissionsSolution = 'Please grant health data permissions in the app settings to enable step tracking.';
  
  // Button Text
  static const String install = 'Install';
  static const String grantPermission = 'Grant Permission';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  
  // UI Messages
  static const String androidHealthNote = 'Note: On Android, you may need to install Google Fit or Samsung Health for step tracking to work properly.';
}