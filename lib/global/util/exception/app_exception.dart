// Base class for custom exceptions in the application
class AppException implements Exception {
  final String message; // Detailed error message
  final String prefix; // Optional prefix for the error message

  AppException(
    this.message, {
    this.prefix = '',
  });

  @override
  String toString() {
    return 'AppException:$prefix$message'; // Formats the exception message with a prefix
  }
}

/// Custom exception class for handling generic or unknown errors in the application.
class CustomException implements Exception {
  final String message;

  CustomException({required this.message});

  @override
  String toString() => message; // Avoid exposing class name in logs/UI
}
