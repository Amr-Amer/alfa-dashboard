import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';

class ShowUserDetailsDialog extends StatelessWidget {
  final UserModel user;

  const ShowUserDetailsDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppConstants.clrBoxBackground,
      title: Text(AppStrings.userDetails, textAlign: TextAlign.center,style: TextStyle(color: AppConstants.clrBigText, fontSize: 16, fontWeight: FontWeight.w600)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailItem('${AppStrings.userId} :', user.uid),
            _buildDetailItem('${AppStrings.userName} :', user.displayName),
            _buildDetailItem('${AppStrings.balance} :','${user.balance} ${GlobalFun.getCurrencyAr(user.currency ?? '')}'),
            _buildDetailItem('${AppStrings.email} :', user.email),
            _buildDetailItem('${AppStrings.phoneNumber} :', user.phoneNumber),
            _buildDetailItem('${AppStrings.address} :', user.address ?? ''),
            _buildDetailItem('${AppStrings.status} :', GlobalFun.getUserStatusAr(user.status)),
            _buildDetailItem('${AppStrings.createdAt} :', GlobalFun.formatedDateTime(user.createdAt?? DateTime.now())),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.close),
        ),
      ],
    );
  }
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.clrBigText,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '--',
              style: TextStyle(color: AppConstants.clrSmallText),
            ),
          ),
        ],
      ),
    );
  }
}
