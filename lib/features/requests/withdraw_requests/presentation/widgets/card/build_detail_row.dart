import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/widgets/card/build_status_dropdown.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/utils/constants.dart';
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
                    BuildWithdrawsStatusDropdown(transaction: transaction),
                    buildDetailsCell('${transaction.amount}',1),
                    buildDetailsCell(GlobalFun.formatedDateTime(transaction.createdAt), 1),
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
}
