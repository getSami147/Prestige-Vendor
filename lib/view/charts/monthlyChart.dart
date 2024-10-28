import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/models/VendorGragh.dart';
import 'package:prestige_vender/utils/colors.dart';
import 'package:prestige_vender/utils/constant.dart';
import 'package:prestige_vender/utils/widget.dart';
import 'package:prestige_vender/view/charts/weeklyChart.dart';
import 'package:prestige_vender/viewModel/homeViewModel.dart';

class MonthlyChart extends StatefulWidget {
  @override
  _MonthlyChartState createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VendorGraghModel>(
      future: HomeViewModel().vendorGrapghAPI(context),
      builder:
          (BuildContext context, AsyncSnapshot<VendorGraghModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoadingIndicator());
        } else 
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.monthlySales == null) {
          return const Center(child: Text('No data available'));
        } else {
          List<MonthlySale> monthly = snapshot.data!.monthlySales!;
          List<WeeklySale> weekly = snapshot.data!.weeklySales!;

          List<FlSpot> spots = monthly
              .asMap()
              .entries
              .map((entry) => FlSpot(
                    entry.key.toDouble(),
                    (entry.value.amount ?? 0).toDouble(),
                  ))
              .toList();

          double maxAmount = monthly.fold(0,
              (prev, sale) => (sale.amount ?? 0) > prev ? sale.amount! : prev);

          double maxY = (maxAmount / 1000).ceilToDouble() * 1000;

          DateTime? startDate = monthly.isNotEmpty ? monthly.first.date : null;
          DateTime? endDate = monthly.isNotEmpty ? monthly.last.date : null;

          return Column(
            children: [
              Container(
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
                            if (value == 0 && startDate != null) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: text(
                                  DateFormat('dd MMM').format(startDate),
                                  fontSize: 9.0,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            } else if (value == spots.length - 1 &&
                                endDate != null) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: text(
                                  DateFormat('dd MMM').format(endDate),
                                  fontSize: 9.0,
                                  color: black,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                fontWeight: FontWeight.w600,
                                fontSize: 10.0,
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
                    maxX: spots.length.toDouble() - 1,
                    minY: 0,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
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
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {
                        if (response != null &&
                            response.lineBarSpots != null &&
                            response.lineBarSpots!.isNotEmpty) {
                          final spot = response.lineBarSpots!.first;
                          final sale = monthly[spot.x.toInt()];
                          final date = sale.date;
                          final amount = sale.amount;
              
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: text('Details',fontSize: textSizeLargeMedium),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(
                                      'Date: ${DateFormat('dd MMM yyyy').format(date!)}',color: colorPrimary,),
                                text('Amount: ${ammoutFormatter(amount!.toInt())} N',color: colorPrimary,),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: text('Close',color: redColor),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ).paddingOnly(right: 20, top: 20),
              ),
            WeeklyChart(weekly: weekly)
              
            ],
          );
        }
      },
    ).paddingTop(spacing_twinty);
  }

  static const List<Color> gradientColors = [
    colorPrimary,
    colorPrimary2,
  ];
}
