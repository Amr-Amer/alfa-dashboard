import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/build_user_detail_row.dart';
import 'package:alfa_dashboard/features/user/presentation/widgets/show_edit_balance_dialog.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class UsersCard extends StatelessWidget {
  UsersCard({super.key});

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
                        buildHeaderCell(Icons.email, AppStrings.email, 1),
                        buildHeaderCell(Icons.account_balance_wallet, AppStrings.balance, 1),
                        buildHeaderCell(Icons.map_rounded, AppStrings.country, 1),
                        buildHeaderCell(Icons.info_outline, AppStrings.status, 1),
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
                      return BuildUserDetailRow(
                        user: state.users[index],
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
