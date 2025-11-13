import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/requests/withdraw_requests/presentation/manager/withdraws_cubit.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildWithdrawsStatusDropdown extends StatelessWidget {
  final TransactionModel transaction;
  const BuildWithdrawsStatusDropdown({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {

    final currentStatus = transaction.status.name;

    return Expanded(
      child: Center(
        child: DropdownButton<String>(
          value: currentStatus,
          dropdownColor: AppConstants.clrBoxBackground,
          underline: SizedBox(),
          iconEnabledColor: AppConstants.clrBigText,
          items: TransactionStatus.values
              .map((status) =>
              DropdownMenuItem<String>(
                value: status.name,
                child: Text(
                  GlobalFun.getStatusAr(status),
                  style: TextStyle(
                      color: AppConstants.clrBigText, fontSize: 13),
                ),
              ))
              .toList(),
          onChanged: (newStatus) async {
            if (newStatus != null && newStatus != currentStatus) {
              String note = '';

              if (newStatus == TransactionStatus.completed.name) {
                note = AppStrings.transactionAddedSuccessfully;
              } else {
                final result = await showDialog<String>(
                  context: context,
                  builder: (_) =>
                      _buildNoteDialog(transaction.adminNote, context: context),
                );

                if (result == null || result.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppStrings.noteRequired)),
                  );
                  return;
                }
                note = result.trim();
              }
              context.read<WithdrawsCubit>().changeWithdrawStatus(
                transaction,
                newStatus,
                userId: transaction.uid,
                userToken: transaction.userToken,
                adminNote: note,
                onError: (msg) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                  }
                  if (kDebugMode) {
                    print("userID ${transaction.uid}");
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
  Widget _buildNoteDialog(String initialNote, {required BuildContext context}) {
    final controller = TextEditingController(text: initialNote);
    return AlertDialog(
      title: Text(AppStrings.inputNote),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: AppStrings.newNote,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
              maxLines: 5,
              minLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.cancel),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.text),
                  child: Text(AppStrings.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
