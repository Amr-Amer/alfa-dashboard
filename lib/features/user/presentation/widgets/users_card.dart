import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_state.dart';
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
      BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if(state is UserLoading){
            return CircularProgressIndicator(color:  AppConstants.clrSmallText);
          }
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
                      // buildHeaderCell(Icons.numbers, AppStrings.numbers, 1),
                      buildHeaderCell(Icons.people, AppStrings.persons, 1),
                      buildHeaderCell(Icons.email, AppStrings.email, 2),
                      buildHeaderCell(Icons.account_balance_wallet, AppStrings.balance, 1),
                      buildHeaderCell(Icons.map_rounded, AppStrings.country, 1),
                      buildHeaderCell(Icons.info_outline, AppStrings.status, 1),
                      buildHeaderCell(Icons.phone, AppStrings.phoneNumber, 1),
                      buildHeaderCell(Icons.place, AppStrings.address, 1),
                      // buildHeaderCell(Icons.book, AppStrings.jobTitle, 1),
                    ],
                  ),
                ),
                // ...detailsList.map((detail) => _buildDetailRow(detail))
                ...state is AllUsersLoaded
                    ? state.users.map((detail) => _buildDetailRow(detail))
                    : [],
              ],
            ),
          );
        },
      );
  }

  Widget _buildDetailRow(UserModel user) {
    return InkWell(
      onTap: () {
        print(user.uid);
      },
      child: Container(
        color: Color(0xFF131D1F),
        padding: EdgeInsets.symmetric( horizontal: 10, vertical: 15),
        child: Row(
          children: [
            // buildDetailsCell(user.uid, 1),
            buildDetailsCell(user.displayName, 1),
            // buildDetailsCellWithImage(user.photoURL ?? '', user.displayName, 1),
            buildDetailsCell(user.email, 2),
            buildDetailsCell(user.balance.toString(), 1),
            buildDetailsCell(user.currency ?? '', 1),
            buildDetailsCell(user.isActive ? 'Active' : 'Inactive', 1),
            buildDetailsCell(user.phoneNumber, 1),
            buildDetailsCell(user.address ?? '', 1),
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
