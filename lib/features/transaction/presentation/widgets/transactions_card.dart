import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                      buildHeaderCell(Icons.av_timer_rounded, AppStrings.transactionTime, 1), // Transaction Time
                      buildHeaderCell(Icons.delete, AppStrings.delete, 1), // Transaction Time
                      buildHeaderCell(Icons.image, AppStrings.receiptImage, 1), // Transaction Time
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
                  buildDetailsCell(GlobalFun.formatDate(transaction.createdAt), 1),
                  buildDeleteCell(transaction.id, 1, context),
                  buildDetailsCellWithImage(transaction.receiptUrl, 1,context)
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

  Widget buildDeleteCell(String transactionId, int flex,BuildContext context) {

    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppConstants.redColor,
            ),
            onPressed: () async {
              await context.read<TransactionCubit>().deleteTransaction(transactionId);
            },
          ),
        ],
      ),
    );
  }

  Widget buildDetailsCellWithImage(String imageUrl, int flex, BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: imageUrl.isEmpty
            ? const Icon(
            Icons.image_not_supported, color: AppConstants.clrBigText)
            : InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    backgroundColor: AppConstants.clrWhite,
                    title: const Text(AppStrings.receiptImage),
                    content: CachedNetworkImage(
                      imageUrl: imageUrl,
                      // height: 50,
                      // width: 50,
                      // fit: BoxFit.contain,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 30,
                          color: AppConstants.clrBigText),
                    ),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              AppConstants.clrBoxBackground),
                        ),
                        child: const Text(AppStrings.close,style: TextStyle(color: AppConstants.clrBigText),),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
            );
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 30,
                      color: AppConstants.clrGradient3);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2,));
                },
              )
          ),
        ),
      ),
    );
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
              _buildDetailItem('${AppStrings.updatedAt} :', GlobalFun.formatedDateTime(transaction.updatedAt)),
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
