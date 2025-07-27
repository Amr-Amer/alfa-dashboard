import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class Chart extends StatelessWidget {
  final List<PieChartSectionData> paiChartSelectionData;
  final String totalTransactions;
  const Chart({super.key, required this.paiChartSelectionData, required this.totalTransactions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionData)),
          Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                totalTransactions,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    height: 0.5),
              ),
              SizedBox(
                height: 8,
              ),
              Text(AppStrings.totalTransactions,style: TextStyle(color: AppConstants.clrSmallText),)
            ],
          ))
        ],
      ),
    );
  }
}
