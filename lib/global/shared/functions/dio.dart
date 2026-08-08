String getErrorMessage(String dioMessage) {
  const String errorMessage = "Something went wrong, please contact to admin";
  if (dioMessage == "null") return errorMessage;
  return dioMessage;
}

String extractErrorMessage(Map<String, dynamic> response) {
  final data = response['data'] ?? response['errors'];

  // If data is not a Map, return the main message
  if (data is! Map<String, dynamic> || data.isEmpty) {
    return response['message'] ?? 'Unknown error';
  }

  // Get the first key in "data"
  final firstKey = data.keys.first;

  // Get the first error message for that key
  final firstErrorList = data[firstKey];
  if (firstErrorList is List && firstErrorList.isNotEmpty) {
    return firstErrorList.first;
  }

  return response['message'] ?? 'Unknown error';
}
