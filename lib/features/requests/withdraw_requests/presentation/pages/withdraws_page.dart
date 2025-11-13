import 'package:alfa_dashboard/core/di/injection_container.dart';

import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/manager/withdraws_cubit.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/widgets/card/withdraws_card.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/widgets/withdraws_search_filter.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const WithdrawsPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => sl<WithdrawsCubit>(),
        child: Scaffold(
          body: BlocBuilder<WithdrawsCubit, WithdrawsState>(
            builder: (context, state) {
              if (state is WithdrawsLoading) {
                return const Center(child: CircularProgressIndicator(color: AppConstants.clrBigText,));
              } else if (state is WithdrawsError) {
                return ErrorWidget(state.message);
              } else if (state is WithdrawsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      // TrnasSearchWidget(),
                      WithdrawsSearchFilter(),
                      SizedBox(height: 20),
                      Expanded(child: WithdrawsCard()),
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
