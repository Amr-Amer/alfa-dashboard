import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildUserSelectionSection extends StatelessWidget {
  const BuildUserSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectRecipient,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.clrBigText,
          ),
        ),
        const SizedBox(height: 10),

        /// 🔹 Dropdown
        DropdownButtonFormField<String>(
          dropdownColor: AppConstants.clrBoxBackground,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppConstants.clrSmallText.withValues(alpha: 0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppConstants.clrSmallText.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppConstants.clrMain, width: 1.5),
            ),
            labelText: AppStrings.selectUser,
            labelStyle: TextStyle(color: AppConstants.clrSmallText),
            filled: true,
            fillColor: AppConstants.clrBoxBackground,
          ),
          initialValue: cubit.selectedUserId.isEmpty ? null : cubit.selectedUserId,
          items: [
            DropdownMenuItem<String>(
              value: 'all',
              child: Row(
                children: [
                  Icon(Icons.group, color: AppConstants.clrMain),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.allUsers,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.clrBigText,
                    ),
                  ),
                ],
              ),
            ),
            const DropdownMenuItem<String>(
              value: 'divider',
              enabled: false,
              child: Divider(height: 10, color: Colors.grey),
            ),
            ...users.map((u) {
              return DropdownMenuItem<String>(
                value: u.uid,
                child: Text(
                  u.displayName,
                  style: TextStyle(color: AppConstants.clrBigText),
                ),
              );
            }),
          ],
          onChanged: (value) {
            if (value == 'all') {
              cubit.selectAllUsers();
            } else if (value != 'divider') {
              final selected = users.firstWhere((u) => u.uid == value);
              cubit.selectUser(selected);
            }
          },
        ),
        hSpace(12),

        _buildSelectedUserInfo(context, cubit),
      ],
    );
  }

  Widget _buildSelectedUserInfo(BuildContext context, NotificationCubit cubit) {
    final isAll = cubit.selectedUserId == 'all';
    final isSelected = cubit.selectedUserId.isNotEmpty && !isAll;

    debugPrint("=========== 🟢 USER SELECTION DEBUG INFO 🟢 ===========");
    debugPrint("Selected User ID: ${cubit.selectedUserId}");
    debugPrint("Selected User Name: ${cubit.selectedUserName}");
    debugPrint("Is All Users Selected? ${isAll ? '✅ YES' : '❌ NO'}");
    debugPrint("Is Single User Selected? ${isSelected ? '✅ YES' : '❌ NO'}");
    debugPrint("=======================================================");


    if (!isAll && !isSelected) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAll
              ? AppConstants.clrMain
              : AppConstants.clrBoxBackground.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAll ? AppConstants.clrMain : AppConstants.clrSmallText.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isAll ? Icons.group : Icons.person,
              color: isAll ? AppConstants.clrMain : AppConstants.clrBigText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAll
                    ? '${AppStrings.sendingToAllUsers} (${users.length})'
                    : '${AppStrings.sendingTo}: ${cubit.selectedUserName}',
                style: TextStyle(
                  color: isAll ? AppConstants.clrMain : AppConstants.clrBigText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
