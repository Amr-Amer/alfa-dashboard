import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_state.dart';
import 'package:alfa_dashboard/features/notifications/presentation/widgets/add_new_notification.dart';
import 'package:alfa_dashboard/features/notifications/presentation/widgets/notification_card.dart';
import 'package:alfa_dashboard/features/transaction/presentation/widgets/transaction_error_widget.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NotificationsPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) =>
          sl<NotificationCubit>()
            ..fetchAllNotifications()),
          BlocProvider(create: (context) =>
          sl<UserCubit>()
            ..fetchAllUsers()),
        ],
        // create: (context) => sl<NotificationsCubit>()..fetchAllNotifications(),
        child: Scaffold(
          body: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppConstants.clrBigText));
              } else if (state is NotificationError) {
                return TransactionErrorWidget(
                  message: state.message,
                  onRetry: () =>
                      context.watch<NotificationCubit>()
                          .fetchAllNotifications(),
                );
              } else if (state is NotificationsLoaded) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                        if (userState is AllUsersLoaded) {
                          return Column(
                            children: [
                              AddNewNotification(users: userState.users),
                              const SizedBox(height: 10),
                              Expanded(child: NotificationsCard()),
                            ],
                          );
                        }
                        return const Center(child: Text(AppStrings.loading));
                      },
                    )

                );
              }
              return const Center(child: Text(AppStrings.loading));
            },
          ),
        ),
      ),
    );
  }
}
