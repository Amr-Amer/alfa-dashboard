import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/domain/entities/user_status.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildUserStatusDropdown extends StatelessWidget {
  final UserModel user;

  const BuildUserStatusDropdown({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final currentStatus = user.status.name;
    return Expanded(
      child: Center(
          child: DropdownButton<String>(
              value: currentStatus,
              dropdownColor: AppConstants.clrBoxBackground,
              underline: SizedBox(),
              iconEnabledColor: AppConstants.clrBigText,
              items: UserStatus.values
                  .map((status) =>
                  DropdownMenuItem<String>(
                    value: status.name,
                    child: Text(
                      GlobalFun.getUserStatusAr(status),
                      style: TextStyle(
                          color: AppConstants.clrBigText, fontSize: 13),
                    ),
                  )).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  final updatedUser = user.copyWith(
                    status: UserStatus.values.firstWhere((s) =>
                    s.name == newValue),
                    updatedAt: DateTime.now(),
                  );
                  await context.read<UserCubit>().updateUserData(updatedUser);
                }
              }
          )
      ),
    );
  }
}
