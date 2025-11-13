import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/requests/top_up/presentation/manager/requests_cubit.dart';
import 'package:alfa_dashboard/features/requests/top_up/presentation/manager/requests_state.dart';
import 'package:alfa_dashboard/features/requests/top_up/presentation/widgets/requests_card.dart';
import 'package:alfa_dashboard/features/requests/top_up/presentation/widgets/requests_filter_search.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawRequestsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const WithdrawRequestsScreen({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => sl<RequestsCubit>(),
        child: Scaffold(
          body: BlocBuilder<RequestsCubit, RequestsState>(
            builder: (context, state) {
              if (state is RequestsLoading) {
                return const Center(child: CircularProgressIndicator(color: AppConstants.clrBigText,));
              } else if (state is RequestsError) {
                return ErrorWidget(state.message);
              } else if (state is RequestsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      // TrnasSearchWidget(),
                      RequestsFilterSearch(),
                      SizedBox(height: 20),
                      Expanded(
                          child: RequestsCard()),
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
