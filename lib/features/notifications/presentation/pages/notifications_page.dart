import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/notifications/presentation/pages/notifications_content.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NotificationsPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationCubit>(),
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text(AppStrings.notifications),
          //   backgroundColor: Theme.of(context).colorScheme.primary,
          //   foregroundColor: Theme.of(context).colorScheme.onPrimary,
          // ),
          body: const NotificationsContent(),
        ),
      ),
    );
  }
}
