import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_cubit.dart';
import 'package:flutter/material.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/features/main/presentation/widgets/custom_card_grid_view.dart';
import 'package:alfa_dashboard/widgets/graph_map_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

  const MainPage({super.key,required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserCubit>()..fetchAllUsers(),),
        BlocProvider(create: (context) => sl<TransactionCubit>()..fetchAllTransactions(),),
        BlocProvider(create: (context) => sl<WithdrawRequestsCubit>()..fetchAllWithdrawsRequest(),),
      ],
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
              SizedBox(
                height: 20,
              ),
              Responsive(
                  mobile: CustomCardGridView(
                    crossAxisCount: MediaQuery.of(context).size.width < 650 ? 2 : 4,
                    childAspectRatio: MediaQuery.of(context).size.width < 650 ? 1.3 : 1.1,
                  ),
                  tablet:CustomCardGridView(
                    crossAxisCount: MediaQuery.of(context).size.width < 800 ? 2 : 4,
                    childAspectRatio: MediaQuery.of(context).size.width < 800 ? 1.5 : 1.2,
                  ),
                  desktop: CustomCardGridView(
                    childAspectRatio: MediaQuery.of(context).size.width < 1400 ? 1.3 : 1.5,
                  ),),
              SizedBox(
                height: 20,
              ),
              Responsive(
                mobile: GraphMapGridView(
                  crossAxisCount: MediaQuery.of(context).size.width < 650 ? 1 : 2,
                  childAspectRatio: MediaQuery.of(context).size.width < 650 ? 1.2 : 1,
                ),
                tablet:GraphMapGridView(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width < 800 ? 1.05 : 1.27,
                ),
                desktop: GraphMapGridView(
                  childAspectRatio: MediaQuery.of(context).size.width < 1400 ? 1.35 : 1.7,
                ),),
              SizedBox(
                height: 20,
              ),
              // DetailsCard()
            ],
          ),
        ),
      ),
    ),
);
  }
}
