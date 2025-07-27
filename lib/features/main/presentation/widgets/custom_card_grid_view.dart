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
        final totalWithdrawRequests = withdrawRequests.length;

        final List<MainCardModel> cards = [
          MainCardModel(
            title: AppStrings.totalUsers,
            subTitle: AppStrings.users,
            iconData: CupertinoIcons.group,
            count: totalUsers.toString(),
            percentage: users.isEmpty ? '0%' : '+2%',
            color: AppConstants.greenColor,
          ),

          MainCardModel(
            title: AppStrings.totalTransactions,
            subTitle: AppStrings.transactions,
            iconData: HugeIcons.strokeRoundedExpander,
            count: totalTransactions.toString(),
            percentage: '+2%',
            color: AppConstants.greenColor,
          ),
        MainCardModel(
            title: AppStrings.totalWithdrawRequests,
            subTitle: AppStrings.withdrawRequests,
            iconData: HugeIcons.strokeRoundedAccess,
            count: totalWithdrawRequests.toString(),
            percentage: '+2%',
            color: AppConstants.greenColor,
          )
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
