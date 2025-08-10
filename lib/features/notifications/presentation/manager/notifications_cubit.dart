import 'dart:async';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/add_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/fetch_all_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/fetch_user_notifications_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_state.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final SendNotificationUseCase sendNotificationUseCase;
  final AddNotificationUseCase addNotificationUseCase;
  final FetchAllNotificationsUseCase fetchAllNotificationsUseCase;
  final FetchUserNotificationsUseCase fetchUserNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;
  StreamSubscription<QuerySnapshot>? _notificationsSubscription;

  NotificationCubit({
    required this.sendNotificationUseCase,
    required this.addNotificationUseCase,
    required this.fetchUserNotificationsUseCase,
    required this.fetchAllNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
  }) : super(NotificationInitial());

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchAllNotifications() async {
    emit(NotificationLoading());
    try {
      final result = await fetchAllNotificationsUseCase.call();
      result.fold(
            (error) => emit(NotificationError(error.message)),
            (notifications) => emit(NotificationsLoaded(notifications, 0)),
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Fetches notifications with optional refresh parameter
  Future<void> fetchNotifications({bool isRefresh = false}) async {
    emit(NotificationLoading());
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      emit(NotificationError('user_not_authenticated'));
      return;
    }
    try {
      // Cancel existing subscription if any
      await _notificationsSubscription?.cancel();

      // Set up real-time listener
      _notificationsSubscription = FirebaseFirestore.instance
          .collection(FirebaseConstants.usersCollection)
          .doc(uid)
          .collection(FirebaseConstants.notificationsCollection)
          .orderBy(FirebaseConstants.createdAt, descending: true)
          .snapshots()
          .listen((snapshot) async {
        if (snapshot.docs.isEmpty) {
          emit(NotificationsLoaded([], 0));
          return;
        }

        try {
          _notifications = snapshot.docs
              .map((doc) => NotificationModel.fromMap({
            ...doc.data(),
            FirebaseConstants.notificationId: doc.id,
          }))
              .toList();
          final unreadCount = _notifications.where((n) => !n.read).length;
          emit(NotificationsLoaded([..._notifications], unreadCount));
        } catch (e) {
          emit(NotificationError('error_parsing_notifications'));
        }
      }, onError: (error) {
        emit(NotificationError('error_loading_notifications'));
      });

      // Perform initial fetch
      final result = await fetchUserNotificationsUseCase.call(uid);
      result.fold(
            (error) => emit(NotificationError(error.message)),
            (notificationsList) {
          _notifications = notificationsList;
          final unreadCount = _notifications.where((n) => !n.read).length;
          emit(NotificationsLoaded([..._notifications], unreadCount));
        },
      );
    } catch (e) {
      emit(NotificationError('error_loading_notifications'));
    }
  }

  /// Marks a single notification as read
  Future<void> markAsRead(String notificationId) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final result = await markNotificationAsReadUseCase.call(
        MarkNotificationAsReadParams(uid: uid, notificationId: notificationId),
      );
      result.fold(
            (error) => _updateLocalNotificationReadStatus(notificationId, true),
            (_) => _updateLocalNotificationReadStatus(notificationId, true),
      );
    } catch (e) {
      _updateLocalNotificationReadStatus(notificationId, true);
    }
  }

  /// Updates local notification read status
  void _updateLocalNotificationReadStatus(String notificationId, bool isRead) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(read: isRead);
      final unreadCount = _notifications.where((n) => !n.read).length;
      emit(NotificationsLoaded([..._notifications], unreadCount));
    }
  }

  /// Marks all notifications as read
  Future<void> markAllAsRead() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final result = await markAllNotificationsAsReadUseCase.call(
        MarkAllNotificationsAsReadParams(uid: uid),
      );
      result.fold(
            (error) => _updateAllLocalNotificationsReadStatus(true),
            (_) => _updateAllLocalNotificationsReadStatus(true),
      );
    } catch (e) {
      _updateAllLocalNotificationsReadStatus(true);
    }
  }

  /// Updates all local notifications read status
  void _updateAllLocalNotificationsReadStatus(bool isRead) {
    _notifications = _notifications.map((n) => n.copyWith(read: isRead)).toList();
    emit(NotificationsLoaded([..._notifications], 0));
  }

  /// Handles notification tap and related actions
  void handleNotificationTap(NotificationModel notification) {
    if (!notification.read) {
      markAsRead(notification.id);
    }

    // Add navigation or other logic based on notification type
    if (kDebugMode) {
      print('Notification tapped: ${notification.id}, Type: ${notification.type}');
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}