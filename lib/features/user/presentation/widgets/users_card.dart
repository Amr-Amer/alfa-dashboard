import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/build_user_status_dropdown.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/show_user_details_dialog.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class UsersCard extends StatelessWidget {
  UsersCard({super.key});

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
          // scrollDirection: Axis.vertical,
          controller: controller,
          child: bottomData(context),
        ),
      ),
    );
  }

  Widget bottomData(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message))
            );
          }
        },
        builder: (context, state) {
          if (state is AllUsersLoaded) {
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
                        buildHeaderCell(Icons.people, AppStrings.persons, 1),
                        buildHeaderCell(Icons.email, AppStrings.email, 2),
                        buildHeaderCell(
                            Icons.account_balance_wallet, AppStrings.balance,
                            1),
                        buildHeaderCell(
                            Icons.map_rounded, AppStrings.country, 1),
                        buildHeaderCell(
                            Icons.info_outline, AppStrings.status, 1),
                        buildHeaderCell(Icons.phone, AppStrings.phoneNumber, 1),
                        buildHeaderCell(Icons.place, AppStrings.address, 1),
                        buildHeaderCell(Icons.delete, AppStrings.delete, 1),
                      ],
                    ),
                  ),
                  // ...state is AllUsersLoaded
                  //     ? state.users.map((detail) => _buildDetailRow(detail, context)).toList()
                  //     : [],
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return _buildDetailRow(
                        state.users[index],
                        context,
                        key: ValueKey(state.users[index].uid),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
                color: AppConstants.clrBigText,));
        }
    );
  }

  Widget _buildDetailRow(UserModel user, BuildContext context, {Key? key}) {
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
              color: isHovered ? AppConstants.clrGradient3: const Color(0xFF131D1F),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  buildDetailsCell(user.displayName, 1),
                  buildDetailsCell(user.email, 2),
                  buildDetailsCell('${user.balance} ${GlobalFun.getCurrencyAr(user.currency ?? '')}', 1),
                  buildDetailsCell(GlobalFun.getCountryAr(user.currency ?? ''), 1),
                  BuildUserStatusDropdown(user: user),
                  buildDetailsCell(user.phoneNumber, 1),
                  buildDetailsCell(user.address ?? '', 1),
                  buildDeleteCell( 1, user.uid, context)
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

  Widget buildDeleteCell(int flex,String uid, BuildContext context) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,color: AppConstants.redColor,),
              onPressed: () async{
                await context.read<UserCubit>().deleteUser(uid);
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

  void _showUserDetailsDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => ShowUserDetailsDialog(user: user),
    );
  }
}
