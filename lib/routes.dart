

import 'package:flutter/cupertino.dart';
import 'package:alfa_dashboard/routes/app_routes.dart';
import 'package:alfa_dashboard/features/dashboard/dashboard_page.dart';

final Map<String,WidgetBuilder> routes = {
  AppRoutes.mainScreen:(context) => DashboardPage(),
};