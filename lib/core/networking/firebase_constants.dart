abstract class FirebaseConstants {

  static const String usersCollection = "users";
  static const String transCollection = "transactions";

  //TODO: User
  static const String uId = "uId";
  static const String address = "address";
  static const String balance = "balance";
  static const String currency = "currency";
  static const String displayName = "displayName";
  static const String email = "email";
  static const String emailVerified = "emailVerified";
  static const String isActive = "isActive";
  static const String isAdmin = "isAdmin";
  static const String languageCode = "languageCode";
  static const String notificationsEnabled = "notificationsEnabled";
  static const String phoneNumber = "phoneNumber";
  static const String photoURL = "photoURL";
  static const String totalEarnings = "totalEarnings";

  //TODO: Transaction
  static const String amount = "amount";
  static const String bankTransactionId = "bankTransactionId";
  static const String commission = "commission";
  static const String transId = "id";
  static const String method = "method";
  static const String note = "note";
  static const String status = "status";
  static const String type = "type";
  static const String deposit = "deposit";
  static const String pending = "pending";
  static const String completed = "completed";
  static const String failed = "failed";
  static const String cancelled = "cancelled";
  static const String adminNote = "adminNote";
  static const String cash = "cash";
  static const String visa = "visa";
  static const String wallet = "wallet";

  //TODO: General
  static const String createdAt = "createdAt";
  static const String updatedAt = "updatedAt";

  static const int searchListLimit = 10;
  static const int transactionsListLimit = 10;
  static const int transactionsAdminListLimit = 50;
  static const int usersListLimit = 10;
  static const int hoursOfWithdrawLimit = 24;
  static const int minimumWithdrawalLimit = 100;

}

abstract class FirebaseErrorKeys {
  // Authentication Errors
  static const String invalidEmail = "invalid_email";
  static const String weakPassword = "weak_password";
  static const String emailAlreadyInUse = "email_already_in_use";
  static const String userDisabled = "user_disabled";
  static const String userNotFound = "user_not_found";
  static const String wrongPassword = "wrong_password";

  // Database Errors
  static const String permissionDenied = "permission_denied";
  static const String notFound = "not_found";
  static const String unavailable = "unavailable";
  static const String invalidArgument = "invalid_argument";

  // Storage Errors
  static const String unauthorized = "unauthorized";
  static const String quotaExceeded = "quota_exceeded";

  // Common Errors
  static const String invalidCredential = "invalid_credential";
  static const String networkError = "network_error";
  static const String cancelled = "cancelled";
  static const String resourceExists = "resource_exists";
  static const String operationNotSupported = "operation_not_supported";
  static const String internalError = "internal_error";
  static const String invalidStateError = "invalid_state_error";
  static const String unknownError = "unknown_error"; // New default key
}

// Arabic translations
const Map<String, String> firebaseArabicMessages = {
  FirebaseErrorKeys.invalidEmail: "تنسيق البريد الإلكتروني غير صالح. يرجى التحقق والمحاولة مرة أخرى.",
  FirebaseErrorKeys.weakPassword: "كلمة المرور ضعيفة جدًا. يرجى اختيار كلمة مرور أقوى.",
  FirebaseErrorKeys.emailAlreadyInUse: "البريد الإلكتروني مستخدم بالفعل. يرجى تسجيل الدخول أو استخدام بريد إلكتروني آخر.",
  FirebaseErrorKeys.userDisabled: "تم تعطيل حساب المستخدم. يرجى الاتصال بالدعم.",
  FirebaseErrorKeys.userNotFound: "المستخدم غير موجود. يرجى التحقق من بياناتك والمحاولة مرة أخرى.",
  FirebaseErrorKeys.wrongPassword: "كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.",
  FirebaseErrorKeys.permissionDenied: "ليس لديك إذن للوصول إلى هذا المورد.",
  FirebaseErrorKeys.notFound: "المورد المطلوب غير موجود.",
  FirebaseErrorKeys.unavailable: "الخدمة غير متوفرة حاليًا. يرجى المحاولة لاحقًا.",
  FirebaseErrorKeys.invalidArgument: "تم تقديم مدخلات غير صالحة. يرجى التحقق والمحاولة مرة أخرى.",
  FirebaseErrorKeys.unauthorized: "غير مصرح لك بإجراء هذه العملية.",
  FirebaseErrorKeys.quotaExceeded: "تم تجاوز الحصة المخصصة. يرجى الاتصال بالدعم أو حذف بعض الملفات.",
  FirebaseErrorKeys.invalidCredential: "البريد الإلكتروني أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.",
  FirebaseErrorKeys.networkError: "خطأ في الشبكة. يرجى التحقق من الاتصال والمحاولة مرة أخرى.",
  FirebaseErrorKeys.cancelled: "تم إلغاء العملية. يرجى المحاولة مرة أخرى.",
  FirebaseErrorKeys.resourceExists: "المورد موجود بالفعل. يرجى التحقق والمحاولة مرة أخرى.",
  FirebaseErrorKeys.operationNotSupported: "هذه العملية غير مدعومة.",
  FirebaseErrorKeys.internalError: "خطأ في الخادم الداخلي. يرجى المحاولة لاحقًا.",
  FirebaseErrorKeys.invalidStateError: "حالة غير صالحة. يرجى التحقق والمحاولة مرة أخرى.",
  FirebaseErrorKeys.unknownError: "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى."
};

// English translations
const Map<String, String> firebaseEnglishMessages = {
  FirebaseErrorKeys.invalidEmail: "Invalid email format. Please check and try again.",
  FirebaseErrorKeys.weakPassword: "Password is too weak. Please choose a stronger password.",
  FirebaseErrorKeys.emailAlreadyInUse: "Email already in use. Please try logging in or use a different email.",
  FirebaseErrorKeys.userDisabled: "User account is disabled. Please contact support.",
  FirebaseErrorKeys.userNotFound: "User not found. Please check your credentials and try again.",
  FirebaseErrorKeys.wrongPassword: "Incorrect password. Please try again.",
  FirebaseErrorKeys.permissionDenied: "You don't have permission to access this resource.",
  FirebaseErrorKeys.notFound: "The requested resource was not found.",
  FirebaseErrorKeys.unavailable: "The service is currently unavailable. Please try again later.",
  FirebaseErrorKeys.invalidArgument: "Invalid arguments provided. Please check your input and try again.",
  FirebaseErrorKeys.unauthorized: "You are not authorized to perform this operation.",
  FirebaseErrorKeys.quotaExceeded: "Storage quota exceeded. Please contact support or delete some files.",
  FirebaseErrorKeys.invalidCredential: "Invalid credential. Please check your input and try again.",
  FirebaseErrorKeys.networkError: "Network error. Please check your internet connection and try again.",
  FirebaseErrorKeys.cancelled: "Operation cancelled. Please try again.",
  FirebaseErrorKeys.resourceExists: "The resource already exists. Please check and try again.",
  FirebaseErrorKeys.operationNotSupported: "This operation is not supported.",
  FirebaseErrorKeys.internalError: "Internal server error. Please try again later.",
  FirebaseErrorKeys.invalidStateError: "Invalid state. Please check your input and try again.",
  FirebaseErrorKeys.unknownError: "An unexpected error occurred. Please try again."
};
