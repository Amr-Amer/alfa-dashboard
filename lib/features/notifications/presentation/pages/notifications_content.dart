import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_state.dart';
import 'package:alfa_dashboard/features/notifications/presentation/widgets/build_action_buttons.dart';
import 'package:alfa_dashboard/features/notifications/presentation/widgets/build_user_selection_section.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsContent extends StatelessWidget {
  const NotificationsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        if (state is NotificationSuccess) {
          _showSuccessSnackBar(context, state.message);
        } else if (state is NotificationError) {
          _showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              _buildSectionTitle(AppStrings.sendNotification),
              const SizedBox(height: 20),

              // User Selection Section
              BuildUserSelectionSection(),
              const SizedBox(height: 24),

              // Notification Body
              _buildNotificationBodyField(context),
              const SizedBox(height: 24),

              // Buttons Section
              BuildActionButtons(isLoading: state is NotificationLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: AppConstants.clrWhite,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNotificationBodyField(BuildContext context) {
    final cubit = context.read<NotificationCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.notificationContent,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.clrSmallText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: cubit.bodyController,
          maxLines: 4,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: AppStrings.bodyHint,
            filled: true,
            fillColor: AppConstants.clrBoxBackground,
          ),
          style: TextStyle(color: AppConstants.clrWhite),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.bodyRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          '${cubit.bodyController.text.length}/500',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}