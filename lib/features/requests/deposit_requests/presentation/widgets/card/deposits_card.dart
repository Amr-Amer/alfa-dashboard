import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/manager/deposits_cubit.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/widgets/card/build_detail_row.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class DepositsCard extends StatelessWidget {
  DepositsCard({super.key});

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller2,
      child: ConstrainedBox(
        constraints:
        BoxConstraints(minWidth: MediaQuery
            .of(context)
            .size
            .width),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: controller,
          child: bottomData(context),
        ),
      ),
    );
  }

  Widget bottomData(BuildContext context) {
    return BlocConsumer<DepositsCubit, DepositsState>(
      listener: (context, state) {
        if (state is DepositsError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message))
          );
        }
      },
      builder: (context, state) {
        if (state is DepositsLoaded) {
          return Container(
            width: 1500,
            decoration: BoxDecoration(
                color: AppConstants.clrBoxBackground,
                boxShadow: [
                  BoxShadow(color: Color(0xff333333), spreadRadius: 1)
                ],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                      color: AppConstants.clrBoxBackground,
                      boxShadow: [
                        BoxShadow(color: Color(0xff333333), spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.all(
                      !Responsive.isMobile(context) ? 20 : 10),
                  child: Row(
                    children: [
                      buildHeaderCell(
                          Icons.numbers, AppStrings.transactionNumbers, 1),
                      buildHeaderCell(Icons.people, AppStrings.userName, 1),
                      buildHeaderCell(Icons.account_balance_sharp, AppStrings.transactionType, 1),
                      buildHeaderCell(Icons.payment, AppStrings.transactionMethod, 2),
                      buildHeaderCell(Icons.info_outline, AppStrings.status, 1),
                      buildHeaderCell(Icons.account_balance_wallet, AppStrings.transactionAmount, 1),
                      // buildHeaderCell(Icons.note_alt_outlined, AppStrings.transactionNotes, 1),
                      buildHeaderCell(Icons.av_timer_rounded, AppStrings.transactionTime, 1),
                      buildHeaderCell(Icons.image, AppStrings.receiptImage, 1), // Transaction Time
                    ],
                  ),
                ),
                // Content
                if(state.transactions.isEmpty)
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(AppStrings.depositsIsEmpty, style: TextStyle(color: AppConstants.clrSmallText),),
                    ),
                  )
                else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    return BuildDetailRow(
                      transaction: state.transactions[index],
                      key: ValueKey(state.transactions[index].id ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildDetailsCellWithImage(String imagePath, String text, int flex) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath.endsWith('.svg')
                ? SvgPicture.asset(
              imagePath,
              width: 20,
            )
                : Image.asset(
              imagePath,
              width: 20,
            ),
            SizedBox(width: 5,),
            Text(
              text,
              style: TextStyle(color: AppConstants.clrBigText, fontSize: 13),
            )
          ],
        ));
  }

  Widget buildHeaderCell(IconData imagePath, String text, int flex) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(imagePath, color: AppConstants.clrSmallText, size: 15,),
            SizedBox(width: 5,),
            Text(
              text,
              style: TextStyle(color: AppConstants.clrBigText, fontSize: 13),
            )
          ],
        ));
  }

}
