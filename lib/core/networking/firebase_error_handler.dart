// firebase_error_handler.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFailure {
  final String code;
  final String message;
  final StackTrace? stackTrace;

  const FirebaseFailure({
    required this.code,
    required this.message,
    this.stackTrace,
  });

  factory FirebaseFailure.fromException(FirebaseException exception) {
    return FirebaseFailure(
      code: exception.code,
      message: exception.message ?? 'Firebase operation failed',
      stackTrace: exception.stackTrace,
    );
  }

  factory FirebaseFailure.unknown([StackTrace? stackTrace]) {
    return FirebaseFailure(
      code: 'unknown-error',
      message: 'An unknown error occurred',
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() => 'FirebaseFailure(code: $code, message: $message)';
}