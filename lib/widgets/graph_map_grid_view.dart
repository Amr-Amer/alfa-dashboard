import 'package:alfa_dashboard/core/models/bottom_card_model.dart';
import 'package:alfa_dashboard/core/models/graph_model.dart';
import 'package:alfa_dashboard/core/networking/firebase_constants.dart';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:alfa_dashboard/responsive.dart';
import 'package:alfa_dashboard/widgets/chart_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphMapGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  const GraphMapGridView(
      {super.key, this.childAspectRatio = 1.5, this.crossAxisCount = 2});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {

        final completeTransactions = transactions.where((t) => t.status.name == FirebaseConstants.completed).length;
        final failedTransactions = transactions.where((t) => t.status.name == FirebaseConstants.failed).length;
        final cancelledTransactions = transactions.where((t) => t.status.name == FirebaseConstants.cancelled).length;
        final pendingTransactions = transactions.where((t) => t.status.name == FirebaseConstants.pending).length;

        List<PieChartSectionData> paiChartSelectionData = [
          PieChartSectionData(
            color: Color(0xFF75E335),
            value: completeTransactions.toDouble(),
            showTitle: false,
            radius: 22,
          ),
          PieChartSectionData(
            color: Color(0xFFEEA468),
            value: failedTransactions.toDouble(),
            showTitle: false,
            radius: 19,
          ),
          PieChartSectionData(
            color: Color(0xFF4F53CE),
            value: cancelledTransactions.toDouble(),
            showTitle: false,
            radius: 16,
          ),
          PieChartSectionData(
            color: Color(0xFFCE6462),
            value: pendingTransactions.toDouble(),
            showTitle: false,
            radius: 25,
          ),
        ];


        List<GraphModel> graphCardData = [
          GraphModel(
              title: AppStrings.completedTransactions,
              subTitle: pendingTransactions.toString(),
              color: Color(0xFF75E335),
              image: ''),
          GraphModel(
              title: AppStrings.pendingTransactions,
              subTitle: completeTransactions.toString(),
              color: Color(0xFFEEA468),
              image: ''),
          GraphModel(
              title: AppStrings.cancelledTransactions,
              subTitle: failedTransactions.toString(),
              color: Color(0xFF4F53CE),
              image: ''),
          GraphModel(
              title: AppStrings.failedTransactions,
              subTitle: cancelledTransactions.toString(),
              color: Color(0xFFCE6462),
              image: ''),
          // GraphModel(
          //     title: AppStrings.completedTransactions,
          //     subTitle: pendingTransactions.toString(),
          //     color: Color(0xFFA83CE5),
          //     image: ''),
        ];


        final bottomCard = [
          BottomCardModel(
            title: AppStrings.transactionsDetails,
            iconData: Icons.connected_tv_outlined,
            type: 0,
            graphData: graphCardData,
          ),
          // BottomCardModel(
          //   title: AppStrings.failedTransactions,
          //   type: 1,
          //   graphData: [],
          //   iconData: Icons.close,
          // ),
        ];

        return GridView.builder(
          itemCount: bottomCard.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
            mainAxisSpacing: 12.0,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) =>
              ChartCard(
                bottomCardModel: bottomCard[index],
                paiChartSelectionData: paiChartSelectionData,totalTransactions: transactions.length.toString(),),
        );
      },
    );
  }
}
