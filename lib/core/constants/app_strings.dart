class AppStrings {
  static const String appTitle = 'Local Api Server';

  // Home app bar
  static const String runTooltip = 'run';
  static const String stopTooltip = 'stop';
  static const String optionsTooltip = 'options';
  static const String portLabel = 'Port';

  // Sidebar
  static const String addEndpoints = 'Add Endpoints';
  static const String noEndpointTitle =
      'No Endpoint created!\nClick Add to create an endpoint';

  // Add endpoint menu
  static const String addManually = 'Add Manually';
  static const String addManuallyDescription =
      'Fill in the endpoint details yourself';
  static const String importSchema = 'Import Schema';
  static const String importSchemaDescription =
      'Generate endpoints from an OpenAPI (Swagger) spec';

  // Server running view
  static const String serverRunning = 'Running !!!';
  static const String stopServer = 'Stop Server';
  static const String copyUrl = 'Copy url';
  static const String urlCopied = 'Copied to clipboard';

  // Terminal
  static const String clearConsole = 'clear console';

  // Errors / dialogs
  static const String noEndpointDialogTitle = 'No Endpoint';
  static const String noEndpointDialogMessage =
      'You have to specify an endpoint before starting a server';
  static const String emptyTitleDialogTitle = 'Empty Title';
  static const String emptyTitleDialogMessage = 'Title should not be empty';
  static const String emptyUrlDialogTitle = 'Empty Endpoint';
  static const String emptyUrlDialogMessage =
      'The endpoint url should not be empty';
  static const String wrongUrlDialogTitle = 'Wrong Url';
  static const String wrongUrlDialogMessage = 'Url should not have spaces';
  static const String endpointExistsDialogTitle = 'Endpoint exists';
  static const String endpointExistsDialogMessage =
      'This endpoint has already been created please use another url';
  static const String deleteEndpointDialogTitle = 'Delete Endpoint';
  static String deleteEndpointDialogMessage(String title) =>
      'Are you sure you want to delete `$title` endpoint';
  static const String importParseErrorTitle = 'Import failed';
  static const String importNoFileSelected = 'No file selected';
  static const String importNoEndpointsFound =
      'No endpoints were found in this schema';
}
