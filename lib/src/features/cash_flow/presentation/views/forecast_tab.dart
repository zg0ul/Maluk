import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Monthly forecast tab showing cash flow projection chart and monthly breakdown
class ForecastTab extends StatelessWidget {
  final MonthlyFinanceData financeData;

  const ForecastTab({required this.financeData, super.key});

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Generate cash flow data for each month
    final cashFlowData = List.generate(
      12,
      (month) => financeData.getMonthlyCashFlow(month),
    );

    // Generate balance data (cumulative)
    final balanceData = List.generate(
      12,
      (month) => financeData.getMonthlyBalance(month),
    );

    return ListView(
      children: [
        // Chart title
        Text(
          'Monthly Cash Flow Projection',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 300.ms),
        AppSpacer.height24,

        // Cash Flow Chart
        SizedBox(
          height: 250.h,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() % 2 == 0) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            monthNames[value.toInt()],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 11,
              lineBarsData: [
                // Cash Flow Line
                LineChartBarData(
                  spots: List.generate(
                    12,
                    (i) => FlSpot(i.toDouble(), cashFlowData[i]),
                  ),
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                // Balance Line
                LineChartBarData(
                  spots: List.generate(
                    12,
                    (i) => FlSpot(i.toDouble(), balanceData[i]),
                  ),
                  isCurved: true,
                  color: Theme.of(context).colorScheme.secondary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

        AppSpacer.height16,

        // Chart Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              context,
              color: Theme.of(context).colorScheme.primary,
              label: 'Monthly Cash Flow',
            ),
            AppSpacer.width24,
            _buildLegendItem(
              context,
              color: Theme.of(context).colorScheme.secondary,
              label: 'Cumulative Balance',
            ),
          ],
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

        AppSpacer.height24,

        // Monthly breakdown cards
        ...List.generate(12, (month) {
          final cashFlow = cashFlowData[month];
          final balance = balanceData[month];
          final hasSpecialTransactions = financeData.specialTransactions.any(
            (trans) => trans.month == month,
          );

          return _buildMonthCard(
            context: context,
            month: month,
            monthName: monthNames[month],
            cashFlow: cashFlow,
            balance: balance,
            hasSpecialTransactions: hasSpecialTransactions,
            specialTransactions:
                financeData.specialTransactions
                    .where((trans) => trans.month == month)
                    .toList(),
            animationDelay: Duration(milliseconds: 200 + (month * 50)),
          );
        }),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacer.width8,
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildMonthCard({
    required BuildContext context,
    required int month,
    required String monthName,
    required double cashFlow,
    required double balance,
    required bool hasSpecialTransactions,
    required List<SpecialTransaction> specialTransactions,
    required Duration animationDelay,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month title
            Text(monthName, style: Theme.of(context).textTheme.titleMedium),
            if (hasSpecialTransactions) ...[
              AppSpacer.height8,
              ...specialTransactions.map(
                (trans) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    '• ${trans.isIncome ? "Income" : "Expense"}: ${trans.name} (${trans.isIncome ? "+" : "-"}\$${trans.amount.toStringAsFixed(2)})',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          trans.isIncome
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
            AppSpacer.height8,
            // Cash flow and balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Cash Flow:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '\$${cashFlow.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        cashFlow >= 0
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance:', style: Theme.of(context).textTheme.bodyMedium),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        balance >= 0
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: animationDelay);
  }
}
