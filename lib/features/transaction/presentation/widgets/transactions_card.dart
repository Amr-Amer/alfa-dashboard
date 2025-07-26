import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class TransactionsCard extends StatelessWidget {
  TransactionsCard({super.key});

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  final ValueNotifier<String?> _hoveredRow = ValueNotifier(null);


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
        child: bottomData(context),
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
                      buildHeaderCell(Icons.numbers, AppStrings.transactionNumbers, 1),     //Transaction Number
                      buildHeaderCell(Icons.people, AppStrings.userName, 1),     // User Name
                      buildHeaderCell(Icons.account_balance_sharp, AppStrings.transactionType, 1),   // Transaction Type
                      buildHeaderCell(Icons.payment, AppStrings.transactionMethod, 1),     // Transaction Method
                      buildHeaderCell(Icons.info_outline, AppStrings.status, 1),      // Transaction Status
                      buildHeaderCell(Icons.account_balance_wallet, AppStrings.transactionAmount, 1),    // Transaction Amount
                      // buildHeaderCell(Icons.note_alt_outlined, AppStrings.transactionNotes, 1),     // Transaction Notes
                      buildHeaderCell(Icons.note_alt_outlined, AppStrings.adminNotes, 1),     // Transaction Notes
                      buildHeaderCell(Icons.av_timer_rounded, AppStrings.transactionTime, 1), // Transaction Time
                    ],
                  ),
                ),
                ...state is TransactionsLoaded
                    ? state.transactions.map((detail) => _buildDetailRow(detail, context)).toList()
                    : [],
              ],
            ),
          );
        },
      );
  }

  Widget _buildDetailRow(TransactionModel transaction, BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoveredRow.value = transaction.id,
      onExit: (_) => _hoveredRow.value = null,
      child: ValueListenableBuilder<String?>(
        valueListenable: _hoveredRow,
        builder: (context, hoveredId, _) {
          final isHovered = hoveredId == transaction.id;
          return InkWell(
            onTap: () {
              if (kDebugMode) {
                print(transaction.id);
              }
              _showTransactionDetailsDialog(context, transaction);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              color: isHovered ? AppConstants.clrGradient3 : const Color(0xFF131D1F),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Row(
                children: [
                  buildDetailsCell(transaction.id, 1),
                  buildDetailsCell(transaction.userName, 1),
                  buildDetailsCell(GlobalFun.getTypeAr(transaction.type), 1),
                  buildDetailsCell(GlobalFun.getMethodAr(transaction.method), 1),
                  buildDetailsCell(GlobalFun.getStatusAr(transaction.status), 1),
                  buildDetailsCell('${transaction.amount}  ${GlobalFun.getCurrencyAr(transaction.currency)}',1),
                  // buildDetailsCell(transaction.note, 1),
                  buildDetailsCell(transaction.adminNote, 1),
                  buildDetailsCell(GlobalFun.formatedDateTime(transaction.createdAt), 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget buildDetailsCell(String text, int flex) {
    final words = text.trim().split(RegExp(r'\s+'));
    final isLong = words.length > 3;
    final preview = isLong ? '${words.sublist(0, 3).join(' ')} ...' : text;

    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            preview,
            style: TextStyle(color: AppConstants.clrBigText, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
            Icon(imagePath,color: AppConstants.clrSmallText,size: 15,),
            SizedBox(width: 5,),
            Text(
              text,
              style: TextStyle(color: AppConstants.clrBigText, fontSize: 13),
            )
          ],
        ));
  }

  void _showTransactionDetailsDialog(BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.clrBoxBackground,
        title: Text(AppStrings.transactionDetails, textAlign: TextAlign.center,style: TextStyle(color: AppConstants.clrBigText, fontSize: 16, fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('${AppStrings.transactionNumbers} :', transaction.id),
              _buildDetailItem('${AppStrings.userName} :', transaction.userName),
              _buildDetailItem('${AppStrings.transactionType} :', GlobalFun.getTypeAr(transaction.type)),
              _buildDetailItem('${AppStrings.transactionMethod} :', GlobalFun.getMethodAr(transaction.method)),
              _buildDetailItem('${AppStrings.transactionStatus} :', GlobalFun.getStatusAr(transaction.status)),
              _buildDetailItem('${AppStrings.transactionAmount} :', '${transaction.amount} ${GlobalFun.getCurrencyAr(transaction.currency)}'),
              _buildDetailItem('${AppStrings.transactionNotes} :', transaction.note),
              _buildDetailItem('${AppStrings.adminNote} :', transaction.adminNote),
              _buildDetailItem('${AppStrings.createdAt} :', GlobalFun.formatedDateTime(transaction.createdAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.clrBigText,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '--',
              style: TextStyle(color: AppConstants.clrSmallText),
            ),
          ),
        ],
      ),
    );
  }
}
