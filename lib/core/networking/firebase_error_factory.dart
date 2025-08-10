import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/networking/firebase_error_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class ErrorFactory {
  static ErrorModel unKnownError() {
    return ErrorModel(
      message: FirebaseErrorKeys.unknownError,
      code: "0",
    );
  }

  static ErrorModel userNotFoundError() {
    return ErrorModel(
      message: FirebaseErrorKeys.userNotFound,
      code: "user-not-found",
    );
  }



  static ErrorModel fromMessage(String message) {
    return ErrorModel(
      message: message,
      code: "custom-error", // A generic code for custom messages
    );
  }

  static ErrorModel userBalanceNullError() {
    return ErrorModel(
      message: FirebaseErrorKeys.userBalanceNotAvailable,
      code: 'user-balance-null',
    );
  }


  static ErrorModel fromFirebaseError(FirebaseException error) {
    String messageKey = _getDefaultMessageForFirebaseError(error);

    return ErrorModel(
      message: messageKey,
      code: error.code,
    );
  }

  static String _getDefaultMessageForFirebaseError(FirebaseException error) {
    switch (error.code) {
    // Authentication Errors
      case FirebaseErrorKeys.invalidEmail:
        return FirebaseErrorKeys.invalidEmail;
      case FirebaseErrorKeys.weakPassword:
        return FirebaseErrorKeys.weakPassword;
      case FirebaseErrorKeys.emailAlreadyInUse:
        return FirebaseErrorKeys.emailAlreadyInUse;
      case FirebaseErrorKeys.userDisabled:
        return FirebaseErrorKeys.userDisabled;
      case FirebaseErrorKeys.userNotFound:
        return FirebaseErrorKeys.userNotFound;
      case FirebaseErrorKeys.wrongPassword:
        return FirebaseErrorKeys.wrongPassword;

    // Database Errors
      case FirebaseErrorKeys.permissionDenied:
        return FirebaseErrorKeys.permissionDenied;
      case FirebaseErrorKeys.notFound:
        return FirebaseErrorKeys.notFound;
      case FirebaseErrorKeys.unavailable:
        return FirebaseErrorKeys.unavailable;
      case FirebaseErrorKeys.invalidArgument:
        return FirebaseErrorKeys.invalidArgument;
      case FirebaseErrorKeys.failedPrecondition: // New case for FAILED_PRECONDITION
        return FirebaseErrorKeys.failedPrecondition;

    // Storage Errors
      case FirebaseErrorKeys.unauthorized:
        return FirebaseErrorKeys.unauthorized;
      case FirebaseErrorKeys.quotaExceeded:
        return FirebaseErrorKeys.quotaExceeded;

    // Common Errors
      case FirebaseErrorKeys.invalidCredential:
        return FirebaseErrorKeys.invalidCredential;
      case FirebaseErrorKeys.networkError:
        return FirebaseErrorKeys.networkError;
      case FirebaseErrorKeys.cancelled:
        return FirebaseErrorKeys.cancelled;
      case FirebaseErrorKeys.resourceExists:
        return FirebaseErrorKeys.resourceExists;
      case 'operation-not-supported':
        return FirebaseErrorKeys.operationNotSupported;
      case FirebaseErrorKeys.internalError:
        return FirebaseErrorKeys.internalError;
      case FirebaseErrorKeys.invalidStateError:
        return FirebaseErrorKeys.invalidStateError;

      default:
        return FirebaseErrorKeys
            .unknownError; // Use this key for any unspecified errors
    }
  }
}
