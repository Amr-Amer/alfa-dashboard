import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/requests/deposit_requests/presentation/widgets/card/build_status_dropdown.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuildDetailRow extends StatelessWidget {
  final TransactionModel transaction;
  BuildDetailRow({super.key, required this.transaction});

  final ValueNotifier<String?> _hoveredRow = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoveredRow.value = transaction.id,
      onExit: (_) => _hoveredRow.value = null,

      child: ValueListenableBuilder<String?>(
          valueListenable: _hoveredRow,
          builder: (context, hoveredId, _) {
            final isHovered = hoveredId == transaction.id;
            return InkWell(
              key: key,
              onTap: () {
                if (kDebugMode) {
                  print(transaction.uid);
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                color: isHovered ? AppConstants.clrGradient3: const Color(0xFF131D1F),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    buildDetailsCell(transaction.id, 1),
                    buildDetailsCell(transaction.userName, 1),
                    buildDetailsCell(GlobalFun.getTypeAr(transaction.type), 1),
                    buildDetailsCell(GlobalFun.getMethodAr(transaction.method), 1),
                    BuildDepositStatusDropdown(transaction: transaction),
                    buildDetailsCell('${transaction.amount}',1),
                    buildDetailsCell(GlobalFun.formatedDateTime(transaction.createdAt), 1),
                    buildDetailsCellWithImage(transaction.receiptUrl, 1,context)
                  ],
                ),
              ),
            );
          }
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
}
