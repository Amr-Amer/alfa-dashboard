import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildActionButtons extends StatelessWidget {
  final bool isLoading;
  const BuildActionButtons({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();
    final hasSelectedUser = cubit.selectedUserId.isNotEmpty;

    return Row(
      children: [
        if (cubit.selectedUserId != 'all' && hasSelectedUser) ...[
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                if (cubit.bodyController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.bodyRequired),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                cubit.sendUserNotification();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 18),
                  SizedBox(width: 8),
                  Text(AppStrings.sendToUser),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],

        if (cubit.selectedUserId == 'all') ...[
          Expanded(
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                if (cubit.bodyController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.bodyRequired),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                cubit.sendAllUserNotification();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group, size: 18),
                  SizedBox(width: 8),
                  Text(AppStrings.sendToAll),
                ],
              ),
            ),
          ),
        ],

        // 🔹 زر المسح
        if (!isLoading) ...[
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {
              cubit.clearForm();
            },
            child: const Text(AppStrings.clear),
          ),
        ],
      ],
    );
  }
}
