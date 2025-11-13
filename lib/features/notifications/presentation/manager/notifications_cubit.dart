import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/add_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_state.dart';
import 'package:alfa_dashboard/features/notifications/presentation/services/send_notification_services.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SendNotificationUseCase _sendNotificationUseCase;
  final AddNotificationUseCase _addNotificationUseCase;

  NotificationCubit(
      this._sendNotificationUseCase,
      this._addNotificationUseCase,
      ) : super(NotificationInitial()) {
    init();
  }

  late final TextEditingController titleController;
  late final TextEditingController bodyController;

  String selectedUserId = '';
  String selectedUserName = '';
  String selectedUserToken = '';

  void init() {
    titleController = TextEditingController();
    bodyController = TextEditingController();
  }

  void selectUser(UserModel user) {
    selectedUserId = user.uid;
    selectedUserName = user.displayName;
    selectedUserToken = user.fcmToken;

    emit(NotificationUserSelected());
  }

  void selectAllUsers(){
    selectedUserId = 'all';
    selectedUserName = AppStrings.allUsers;
    selectedUserToken = '';
    emit(NotificationAllUsersSelected());
  }

  Future<void> sendUserNotification() async {
    final title = AppStrings.notificationTitleFromAdmin;

    final notification = NotificationModel(
      id: GlobalFun.generateId(),
      uid: selectedUserId,
      title: title,
      body: bodyController.text.trim(),
      createdAt: DateTime.now(),
      read: false,
      status: TransactionStatus.general,
      fcmToken: selectedUserToken,
      name: selectedUserName,
      type: TransactionType.general,
    );

    final result = await _sendNotificationUseCase.call(notification);

    result.fold(
          (error) => emit(NotificationError(error.message)),
          (_) async {
        await sendNotification(
          token: selectedUserToken,
          title: title,
          body: bodyController.text.trim(),
          data: {},
        );
        emit(NotificationSentSuccessfully(message: 'Notification sent successfully'));
        clearForm(keepSelection: true);

          },
    );
  }

  Future<void> sendAllUserNotification() async {
    final title = AppStrings.notificationTitleFromAdmin;
    debugPrint("🚀 Sending notification to ALL users...");

    final notification = NotificationModel(
      id: GlobalFun.generateId(),
      uid: "all",
      title: title,
      body: bodyController.text.trim(),
      createdAt: DateTime.now(),
      read: false,
      status: TransactionStatus.general,
      fcmToken: selectedUserToken,
      name: selectedUserName,
      type: TransactionType.general,
    );
    final result = await _addNotificationUseCase.call(notification);

    result.fold(
          (error) {
        debugPrint("❌ Failed to add notification: ${error.message}");
        emit(NotificationError(error.message));
      },
          (_) async {
        debugPrint("✅ Notification added, now sending to all users...");
        await sendNotificationToAll(
          title: title,
          body: bodyController.text.trim(),
          data: {},
        );
        debugPrint("✅ sendNotificationToAll() finished successfully");
        emit(NotificationSentSuccessfully(message: 'Notification sent successfully'));
        clearForm(keepSelection: true);

          },
    );
  }


  void clearForm({bool keepSelection = true}) {
    titleController.clear();
    bodyController.clear();
    if (!keepSelection) {
      selectedUserId = '';
      selectedUserName = '';
      selectedUserToken = '';
    }
    emit(NotificationInitial());
  }

}
