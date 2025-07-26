import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_cubit.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_state.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/widgets/withdarw_requests_card.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/widgets/withdraw_requests_filter_search.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawRequestsScreen extends StatelessWidget {
  const WithdrawRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<WithdrawRequestsCubit>()..fetchAllWithdrawsRequest()),
          BlocProvider(create: (context) => sl<UserCubit>()..fetchAllUsers()),
        ],
        // create: (context) => sl<WithdrawRequestsCubit>()..fetchAllWithdrawsRequest(),
        child: Scaffold(
          body: BlocBuilder<WithdrawRequestsCubit, WithdrawRequestsState>(
            builder: (context, state) {
              if (state is WithdrawRequestsLoading) {
                return const Center(child: CircularProgressIndicator(color: AppConstants.clrBigText,));
              } else if (state is WithdrawRequestsError) {
                return ErrorWidget(state.message);
              } else if (state is WithdrawRequestsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      // TrnasSearchWidget(),
                      WithdrawRequestsFilterSearch(),
                      SizedBox(height: 20),
                      Expanded(
                          child: WithdrawsRequestsCard()),
                    ],
                  ),
                );
              }
              return Center(child: Text(AppStrings.loading));
            },
          ),
        ),
      ),
    );
  }
}
