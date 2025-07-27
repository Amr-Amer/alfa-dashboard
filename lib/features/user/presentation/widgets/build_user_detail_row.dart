import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/build_user_status_dropdown.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/show_user_details_dialog.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BuildUserDetailRow extends StatelessWidget {
  final UserModel user;

  BuildUserDetailRow({super.key, required this.user});

  final ValueNotifier<String?> _hoveredRow = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoveredRow.value = user.uid,
      onExit: (_) => _hoveredRow.value = null,
      child: ValueListenableBuilder<String?>(
        valueListenable: _hoveredRow,
        builder: (context, hoveredId, _) {
          final isHovered = hoveredId == user.uid;
          return InkWell(
            key: key,
            onTap: () {
              _showUserDetailsDialog(context, user);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              color: isHovered ? AppConstants.clrGradient3 : const Color(
                  0xFF131D1F),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  buildDetailsCell(user.displayName, 1),
                  buildDetailsCell(user.email, 1),
                  buildDetailsCell('${user.balance} ${GlobalFun.getCurrencyAr(user.currency ?? '')}', 1),
                  buildDetailsCell(GlobalFun.getCountryAr(user.currency ?? ''), 1),
                  BuildUserStatusDropdown(user: user),
                  buildDetailsCell(user.phoneNumber, 1),
                  buildDetailsCell(user.address ?? '', 1),
                  buildDeleteCell(1, user.uid, context)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDetailsCell(String text, int flex,) {
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

  Widget buildDeleteCell(int flex, String uid, BuildContext context) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete, color: AppConstants.redColor,),
              onPressed: () async {
                await context.read<UserCubit>().deleteUser(uid);
              },
            )
          ],
        ));
  }

  Widget buildUpdateBalanceCell(int flex, String uid, BuildContext context,TextEditingController controller) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: AppConstants.redColor,),
              onPressed: () async {
                await context.read<UserCubit>().updateUserBalance(double.parse(controller.text), uid);
              },
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

  void _showUserDetailsDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => ShowUserDetailsDialog(user: user),
    );
  }

  void _showEditBalanceDialog(BuildContext context, UserModel user) {
    final TextEditingController controller = TextEditingController(text: user.balance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تعديل الرصيد"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "الرصيد الجديد",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                final newBalance = double.tryParse(controller.text);
                if (newBalance != null) {
                  context.read<UserCubit>().updateUserBalance(newBalance, user.uid);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("الرجاء إدخال رقم صحيح"))
                  );
                }
              },
              child: Text("حفظ"),
            ),
          ],
        );
      },
    );
  }

}
