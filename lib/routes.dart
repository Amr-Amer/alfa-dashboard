

import 'package:flutter/cupertino.dart';
import 'package:alfa_dashboard/routes/app_routes.dart';
import 'package:alfa_dashboard/screens/dashboard_screen.dart';

final Map<String,WidgetBuilder> routes = {
  AppRoutes.mainScreen:(context) => DashboardScreen(),
};