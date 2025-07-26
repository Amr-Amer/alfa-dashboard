import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/transaction/data/models/transaction_model.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_cubit.dart';
import 'package:alfa_dashboard/features/withdraw_requests/presentation/manager/withdraw_state.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class WithdrawsRequestsCard extends StatelessWidget {
  WithdrawsRequestsCard({super.key});

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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: controller,
          child: bottomData(context),
        ),
      ),
    );
  }

  Widget bottomData(BuildContext context) {
    // return
    //   BlocBuilder<WithdrawRequestsCubit, WithdrawRequestsState>(
    //     builder: (context, state) {
    //       return Container(
    //         width: 1500,
    //         decoration: BoxDecoration(
    //             color: AppConstants.clrBoxBackground,
    //             boxShadow: [
    //               BoxShadow(color: Color(0xff333333), spreadRadius: 1)
    //             ],
    //             borderRadius: BorderRadius.all(Radius.circular(10))),
    //         child: Column(
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                   color: AppConstants.clrBoxBackground,
    //                   boxShadow: [
    //                     BoxShadow(color: Color(0xff333333), spreadRadius: 1)
    //                   ],
    //                   borderRadius: BorderRadius.all(Radius.circular(10))),
    //               padding: EdgeInsets.all(
    //                   !Responsive.isMobile(context) ? 20 : 10),
    //               child: Row(
    //                 children: [
    //                   buildHeaderCell(
    //                       Icons.numbers, AppStrings.transactionNumbers, 1),
    //                   buildHeaderCell(Icons.people, AppStrings.userName, 1),
    //                   buildHeaderCell(Icons.account_balance_sharp,
    //                       AppStrings.transactionType, 1),
    //                   buildHeaderCell(
    //                       Icons.payment, AppStrings.transactionMethod, 2),
    //                   buildHeaderCell(Icons.info_outline, AppStrings.status, 1),
    //                   buildHeaderCell(Icons.account_balance_wallet,
    //                       AppStrings.transactionAmount, 1),
    //                   buildHeaderCell(
    //                       Icons.note_alt_outlined, AppStrings.transactionNotes,
    //                       1),
    //                   buildHeaderCell(
    //                       Icons.av_timer_rounded, AppStrings.transactionTime,
    //                       1),
    //                 ],
    //               ),
    //             ),
    //             // ...detailsList.map((detail) => _buildDetailRow(detail))
    //             ...state is WithdrawRequestsLoaded
    //                 ? state.transactions.map((detail) =>
    //                 _buildDetailRow(detail, context)).toList()
    //                 : [],
    //           ],
    //         ),
    //       );
    //     },
    //   );
    return BlocConsumer<WithdrawRequestsCubit, WithdrawRequestsState>(
      listener: (context, state) {
        if (state is WithdrawRequestsError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message))
          );
        }
      },
      builder: (context, state) {
        if (state is WithdrawRequestsLoaded) {
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
                      buildHeaderCell(Icons.note_alt_outlined, AppStrings.transactionNotes, 1),
                      buildHeaderCell(Icons.av_timer_rounded, AppStrings.transactionTime, 1),
                    ],
                  ),
                ),
                // Content
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    return _buildDetailRow(
                      state.transactions[index],
                      context,
                      key: ValueKey(state.transactions[index].id),
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

  Widget _buildDetailRow(TransactionModel transaction, BuildContext context , {Key? key}) {
    return  MouseRegion(
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
                  _buildStatusDropdown(transaction, context),
                  buildDetailsCell('${transaction.amount} ${GlobalFun.getCurrencyAr(transaction.currency)}',1),
                  buildDetailsCell(transaction.note, 1),
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

  Widget _buildStatusDropdown(TransactionModel transaction, BuildContext context) {
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
              )).toList(),
          onChanged: (newStatus) async {
            if (newStatus != null && newStatus != currentStatus) {
              String note = '';

              if (newStatus == TransactionStatus.completed.name) {
                note = "تم إضافة التحويل بنجاح";
              } else {
                final result = await showDialog<String>(
                  context: context,
                  builder: (_) => _buildNoteDialog(transaction.adminNote ?? '', context: context),
                );

                if (result == null || result.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("يجب كتابة الملاحظة قبل تغيير الحالة")),
                  );
                  return;
                }

                note = result.trim();
              }

              context.read<WithdrawRequestsCubit>().changeWithdrawStatus(
                transaction,
                newStatus,
                userId: transaction.uid,
                adminNote: note,
                onError: (msg) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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

}
