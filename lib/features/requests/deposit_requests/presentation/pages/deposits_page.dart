import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/manager/deposits_cubit.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/widgets/card/deposits_card.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/widgets/deposits_search_filter.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepositsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DepositsPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => sl<DepositsCubit>(),
        child: Scaffold(
          body: BlocBuilder<DepositsCubit, DepositsState>(
            builder: (context, state) {
              if (state is DepositsLoading) {
                return const Center(child: CircularProgressIndicator(color: AppConstants.clrBigText,));
              } else if (state is DepositsError) {
                return ErrorWidget(state.message);
              } else if (state is DepositsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      // TrnasSearchWidget(),
                      DepositsSearchFilter(),
                      SizedBox(height: 20),
                      Expanded(child: DepositsCard()),
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
