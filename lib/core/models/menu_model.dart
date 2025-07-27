import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';

class MenuModel {
  IconData icon;
  String title;

  MenuModel({required this.icon, required this.title});
}

List<MenuModel> menu = [
  MenuModel(icon: Icons.home, title: AppStrings.dashboard),
  MenuModel(icon: Icons.supervised_user_circle_outlined, title: AppStrings.users),
  MenuModel(icon: Icons.sync_alt_rounded, title: AppStrings.transactions),
  MenuModel(icon: Icons.account_balance_wallet, title: AppStrings.withdrawRequests),
  // MenuModel(icon: Icons.payment_rounded, title: AppStrings.payroll),
];

List<MenuModel> bottomMenu = [
  // MenuModel(icon: Icons.settings, title: "Settings"),
  // MenuModel(icon: Icons.logout, title: "Log Out"),
];