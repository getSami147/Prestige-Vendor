import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/VendorGragh.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';

class WeeklyChart extends StatefulWidget {
  List<WeeklySale> weekly;

  WeeklyChart({required this.weekly, super.key});
  @override
  _WeeklyChartState createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  @override
  Widget build(BuildContext context) {
    List<FlSpot> spotsWeekly = widget.weekly
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value.amount ?? 0).toDouble(),
            ))
        .toList();

    int maxAmountWeekly = widget.weekly.fold(
        0, (prev, sale) => (sale.amount ?? 0) > prev ? sale.amount! : prev);

    double maxYweekly = (maxAmountWeekly / 1000).ceilToDouble() * 1000;

    var startDateWeekly =
        widget.weekly.isNotEmpty ? widget.weekly.first.day : null;
    var endDateWeekly =
        widget.weekly.isNotEmpty ? widget.weekly.last.day : null;

    //  FutureBuilder<VendorGraghModel>(
    //   future: HomeViewModel().vendorGrapghAPI(context),
    //   builder: (BuildContext context, AsyncSnapshot<VendorGraghModel> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CustomLoadingIndicator());
    //     } else if (snapshot.hasError) {
    //       return Center(child: Text('Error: ${snapshot.error}'));
    //     } else if (!snapshot.hasData || snapshot.data!.weeklySales == null) {
    //       return const Center(child: Text('No data available'));
    //     } else {

    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffFFFFFF),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 24,
            color: const Color(0xff333333).withOpacity(.2),
          ),
        ],
      ),
      height: 300,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1000,
              verticalInterval: 1000,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: Color(0xffe5e5e5),
                strokeWidth: 1,
              ),
              getDrawingVerticalLine: (value) => const FlLine(
                color: Color(0xffe5e5e5),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    if (value == 0 && startDateWeekly != null) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: text(
                          startDateWeekly,
                          fontSize: 9.0,
                          color: black,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else if (value == spotsWeekly.length - 1 &&
                        endDateWeekly != null) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: text(
                          endDateWeekly,
                          fontSize: 9.0,
                          color: black,
                          fontWeight: FontWeight.w500,
                        ).paddingRight(20),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    final formattedValue =
                        NumberFormat.compact().format(value.toInt());
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: text(
                        formattedValue,
                        fontSize: 9.0,
                        color: black,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: colorPrimary),
            ),
            minX: 0,
            maxX: spotsWeekly.length.toDouble() - 1,
            minY: 0,
            maxY: maxYweekly,
            lineBarsData: [
              LineChartBarData(
                spots: spotsWeekly,
                isCurved: true,
                gradient: const LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: true,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: gradientColors
                        .map((color) => color.withOpacity(0.3))
                        .toList(),
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: EdgeInsets.zero,
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    return null;
                  }).toList();
                },
              ),
              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                if (response != null &&
                    response.lineBarSpots != null &&
                    response.lineBarSpots!.isNotEmpty) {
                  final spot = response.lineBarSpots!.first;
                  final sale = widget.weekly[spot.x.toInt()];
                  final date = sale.day;
                  final amount = sale.amount;

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:  text('Details',fontSize: textSizeLargeMedium),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('Day: $date',color: colorPrimary),
                          text('Amount: ${amount.toString()} N',color: colorPrimary),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child:  text('Close',color: redColor),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    ).paddingOnly(top: spacing_middle);
    //     }
    //   },
    // )
    // .paddingTop(spacing_middle);
  }

  static const List<Color> gradientColors = [
    colorPrimary,
    colorPrimary2,
  ];
}
