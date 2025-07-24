import 'dart:math';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';

class GlobalFun {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  // static Color getStatusColor(TransactionStatus status) {
  //   switch (status.name.toLowerCase()) {
  //     case FirebaseConstants.completed:
  //       return AppColors.greenColor;
  //     case FirebaseConstants.pending:
  //       return AppColors.orangeColor;
  //     case FirebaseConstants.failed:
  //       return AppColors.redColor;
  //     case FirebaseConstants.cancelled:
  //       return AppColors.blue600Color;
  //     default:
  //       return AppColors.gray1Color;
  //   }
  // }

  static String generateTransactionId() {
    final now = DateTime.now();
    final random = Random().nextInt(20) + 1;

    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(1, '0');
    final day = now.day.toString().padLeft(1, '0');
    final hour = now.hour.toString().padLeft(1, '0');
    final minute = now.minute.toString().padLeft(1, '0');

    return 'A-$year$month$day$hour$minute$random';
  }
}


UserModel? userModel;
List<UserModel> usersList = [];
UserModel? get user => userModel;


Widget hSpace (double h) {
  return SizedBox(
    height: h,
  );
}

Widget wSpace(double w) {
  return SizedBox(
    width: w,
  );
}
