import 'package:alfa_dashboard/core/models/main_card_model.dart';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/widgets/custom_card.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomCardGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const CustomCardGridView({
    super.key,
    this.childAspectRatio = 1,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final totalUsers = users.length;
        final totalTransactions = transactions.length;
        final totalWithdraws = withdrawRequests.length;
        final totalDeposits = depositRequests.length;

        final List<MainCardModel> cards = [
          MainCardModel(
            title: AppStrings.totalUsers,
            subTitle: AppStrings.users,
            iconData: CupertinoIcons.group,
            count: totalUsers.toString(),
            percentage: users.isEmpty ? '0%' : '100%',
            color: users.isEmpty ? AppConstants.redColor : AppConstants.greenColor,
          ),

          MainCardModel(
            title: AppStrings.totalTransactions,
            subTitle: AppStrings.transactions,
            iconData: HugeIcons.strokeRoundedExpander,
            count: totalTransactions.toString(),
            percentage: transactions.isEmpty ? '0%' : '100%',
            color: transactions.isEmpty ? AppConstants.redColor : AppConstants.greenColor,
          ),
        MainCardModel(
            title: AppStrings.totalWithdrawRequests,
            subTitle: AppStrings.withdrawRequests,
            iconData: HugeIcons.strokeRoundedAccess,
            count: totalWithdraws.toString(),
            percentage: totalWithdraws == 0 ? '0%' : '100%',
            color: totalWithdraws.toString().isEmpty ? AppConstants.redColor : AppConstants.greenColor,
          ),
          MainCardModel(
            title: AppStrings.totalDepositRequests,
            subTitle: AppStrings.deposit,
            iconData: HugeIcons.strokeRoundedAccess,
            count: totalDeposits.toString(),
            percentage: totalDeposits == 0 ? '0%' : '100%',
            color: totalDeposits.toString().isEmpty ? AppConstants.redColor : AppConstants.greenColor,
          ),
        ];

        return GridView.builder(
          itemCount: cards.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
            mainAxisSpacing: 12.0,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => CustomCard(mainCardModel: cards[index]),
        );
      },
    );
  }
}