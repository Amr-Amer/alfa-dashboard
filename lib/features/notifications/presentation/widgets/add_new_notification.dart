import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_state.dart';
import 'package:alfa_dashboard/features/notifications/presentation/widgets/add_notification_dialog.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewNotification extends StatelessWidget {
  final List<UserModel> users;
  const AddNewNotification({super.key,required this.users});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          backgroundColor: AppConstants.clrPrimary,
          icon: const Icon(Icons.add),
          foregroundColor: AppConstants.clrWhite,
          label: const Text(AppStrings.addNewNotification),
          onPressed: () => showAddNewNotificationDialog(context),
        );
      },
    );
  }

  void showAddNewNotificationDialog(BuildContext context) {
    if (users.isNotEmpty) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return BlocProvider.value(
            value: context.read<NotificationCubit>(),
            child: AddNotificationDialog(users: users),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppStrings.noUsersFound)),
      );
    }
  }
}
