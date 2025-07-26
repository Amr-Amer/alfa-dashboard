import 'dart:math';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_method.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
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

  static Color getStatusColor(TransactionStatus status) {
    switch (status.name.toLowerCase()) {
      case FirebaseConstants.completed:
        return AppConstants.greenColor;
      case FirebaseConstants.pending:
        return AppConstants.orangeColor;
      case FirebaseConstants.failed:
        return AppConstants.redColor;
      case FirebaseConstants.cancelled:
        return AppConstants.blue600Color;
      default:
        return AppConstants.gray1Color;
    }
  }

  static String getTypeAr(TransactionType type) {
    switch (type.name.toLowerCase()) {
      case FirebaseConstants.deposit:
        return AppStrings.deposit;
      case FirebaseConstants.withdraw:
        return AppStrings.withdraw;
      default:
        return AppStrings.unknown;
    }
  }

  static String getMethodAr(TransactionMethod method) {
    switch (method.name.toLowerCase()) {
      case FirebaseConstants.visa:
        return AppStrings.visa;
      case FirebaseConstants.wallet:
        return AppStrings.wallet;
      case FirebaseConstants.cash:
        return AppStrings.cash;
      default:
        return AppStrings.unknown;
    }
  }

  static String getStatusAr(TransactionStatus status) {
    switch (status.name.toLowerCase()) {
      case FirebaseConstants.completed:
        return AppStrings.completed;
      case FirebaseConstants.pending:
        return AppStrings.pending;
      case FirebaseConstants.failed:
        return AppStrings.failed;
      case FirebaseConstants.cancelled:
        return AppStrings.cancelled;
      default:
        return AppStrings.unknown;
    }
  }

  static String getCurrencyAr(String currency) {
    switch (currency) {
      case FirebaseConstants.egyptCurrency:
        return AppStrings.egyptCurrency;
      default:
        return AppStrings.unknown;
    }
  }


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


  static String formatedDateTime(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}  ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
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

