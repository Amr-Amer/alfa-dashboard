import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/notifications/data/models/notification_model.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:alfa_dashboard/features/notifications/presentation/manager/notifications_state.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_type.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/utils/constants.dart';

class NotificationsCard extends StatelessWidget {
  NotificationsCard({super.key});

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
      BlocBuilder<NotificationCubit, NotificationState>(
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
                  padding: EdgeInsets.all(!Responsive.isMobile(context) ? 20 : 10),
                  child: Row(
                    children: [
                      buildHeaderCell(Icons.people, AppStrings.userName, 1),
                      buildHeaderCell(Icons.people, AppStrings.notificationType, 1),
                      buildHeaderCell(Icons.info_outline, AppStrings.notificationStatus, 1),
                      buildHeaderCell(Icons.account_balance_wallet, AppStrings.amount, 1),
                      buildHeaderCell(Icons.av_timer_rounded, AppStrings.notificationDate, 1),
                      // buildHeaderCell(Icons.edit, AppStrings.edit, 1),
                    ],
                  ),
                ),
                ...state is NotificationsLoaded
                    ? state.notifications.map((detail) => _buildDetailRow(detail, context)).toList()
                    : [],
              ],
            ),
          );
        },
      );
  }

  Widget _buildDetailRow(NotificationModel notification, BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoveredRow.value = notification.id,
      onExit: (_) => _hoveredRow.value = null,
      child: ValueListenableBuilder<String?>(
        valueListenable: _hoveredRow,
        builder: (context, hoveredId, _) {
          final isHovered = hoveredId == notification.id;
          return InkWell(
            onTap: () {
              if (kDebugMode) {
                print(notification.id);
              }
              _showTransactionDetailsDialog(context, notification);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              color: isHovered ? AppConstants.clrGradient3 : const Color(0xFF131D1F),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Row(
                children: [
                  buildDetailsCell(notification.name ?? '', 1),
                  buildDetailsCell(GlobalFun.getTypeAr(notification.type!), 1),
                  buildDetailsCell(notification.status ?? '', 1),
                  buildDetailsCell('${notification.data?[FirebaseConstants.amount]}',1),
                  buildDetailsCell(GlobalFun.formatedDateTime(notification.createdAt), 1),
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

  void _showTransactionDetailsDialog(BuildContext context, NotificationModel notification) {
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
              _buildDetailItem('${AppStrings.notificationNumber} :', notification.id),
              _buildDetailItem('${AppStrings.notificationTitle} :', notification.title),
              _buildDetailItem('${AppStrings.notificationBody} :', notification.body),
              _buildDetailItem('${AppStrings.notificationStatus} :', notification.status ?? ''),
              _buildDetailItem('${AppStrings.userId} :', notification.uid),
              _buildDetailItem('${AppStrings.userName} :', notification.name ?? ''),
              _buildDetailItem('${AppStrings.notificationType} :', notification.type?.name ?? ''),
              _buildDetailItem('${AppStrings.amount} :', '${notification.data?[FirebaseConstants.amount]}'),
              _buildDetailItem('${AppStrings.notificationDate} :', GlobalFun.formatedDateTime(notification.createdAt)),
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
