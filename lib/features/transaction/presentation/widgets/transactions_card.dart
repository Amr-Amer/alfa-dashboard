import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller2,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: controller,
          child: bottomData(context),
        ),
      ),
    );
  }

  Widget bottomData(BuildContext context) {
    return
      BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
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
                      buildHeaderCell(Icons.numbers, AppStrings.transactionNumbers, 1),
                      buildHeaderCell(Icons.people, AppStrings.transactionType, 1),
                      buildHeaderCell(Icons.email, AppStrings.transactionMethod, 2),
                      buildHeaderCell(Icons.info_outline, AppStrings.status, 1),
                      // buildHeaderCell(Icons.map_rounded, AppStrings.country, 1),
                      buildHeaderCell(Icons.account_balance_wallet, AppStrings.transactionAmount, 1),
                      buildHeaderCell(Icons.note_alt_outlined, AppStrings.transactionNotes, 1),
                      buildHeaderCell(Icons.av_timer_rounded, AppStrings.transactionTime, 1),
                      // buildHeaderCell(Icons.book, AppStrings.jobTitle, 1),
                    ],
                  ),
                ),
                // ...detailsList.map((detail) => _buildDetailRow(detail))
                ...state is TransactionsLoaded
                    ? state.transactions.map((detail) => _buildDetailRow(detail))
                    : [],
              ],
            ),
          );
        },
      );
  }

  Widget _buildDetailRow(TransactionModel transaction) {
    return InkWell(
      onTap: () {
        print(transaction.id);
      },
      child: Container(
        color: Color(0xFF131D1F),
        padding: EdgeInsets.symmetric( horizontal: 10, vertical: 15),
        child: Row(
          children: [
            buildDetailsCell(transaction.id, 1),
            buildDetailsCell(transaction.type.name, 1),
            // buildDetailsCellWithImage(user.photoURL ?? '', user.displayName, 1),
            buildDetailsCell(transaction.method.name, 1),
            buildDetailsCell(transaction.status.name, 1),
            // buildDetailsCell(transaction.currency, 1),
            buildDetailsCell(transaction.amount.toString(), 1),
            buildDetailsCell(transaction.note, 1),
            buildDetailsCell(transaction.createdAt.toString(), 1),
          ],
        ),
      ),
    );
  }

  Widget buildDetailsCell(String text, int flex) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(color: AppConstants.clrBigText, fontSize: 13),
        )
      ],
    ));
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
            Icon(imagePath,color: AppConstants.clrSmallText,size: 15,),
            SizedBox(width: 5,),
            Text(
              text,
              style: TextStyle(color: AppConstants.clrBigText, fontSize: 13),
            )
          ],
        ));
  }
}
