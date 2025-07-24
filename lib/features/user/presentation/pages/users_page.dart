import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/users_card.dart';
import 'package:alfa_dashboard/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const UsersPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserCubit>()..fetchAllUsers(),
  child: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 15 : 10),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 5 : 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HeaderWidget(scaffoldKey: scaffoldKey),
              ),
              SizedBox(
                height: 20,
              ),
              UsersCard()
            ],
          ),
        ),
      ),
    ),
);
  }
}
