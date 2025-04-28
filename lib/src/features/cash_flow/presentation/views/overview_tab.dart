import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Overview tab displaying monthly income, expenses and net cash flow
class OverviewTab extends StatelessWidget {
  final MonthlyFinanceData financeData;
  final TextEditingController incomeController;
  final Function(double) onIncomeChanged;

  const OverviewTab({
    required this.financeData,
    required this.incomeController,
    required this.onIncomeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final netMonthly =
        financeData.monthlyIncome - financeData.totalMonthlyExpense;
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

    return ListView(
      children: [
        // Income Summary Card
        Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Income',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacer.height8,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: incomeController,
                        decoration: InputDecoration(
                          prefixText: '\$ ',
                          contentPadding: EdgeInsets.all(10.r),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.1,
                              color:
                                  Theme.of(context).dividerTheme.color ??
                                  Colors.grey,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.1,
                              color:
                                  Theme.of(context).dividerTheme.color ??
                                  Colors.grey,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            onIncomeChanged(double.parse(value));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Expenses Summary Card
        Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Expenses',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacer.height16,
                ...financeData.monthlyExpenses.map(
                  (expense) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expense.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '\$${expense.amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 24.h, thickness: 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Expenses',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '\$${financeData.totalMonthlyExpense.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Special Transactions Card
        if (financeData.specialTransactions.isNotEmpty)
          Card(
            margin: EdgeInsets.only(bottom: 16.h),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Transactions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  AppSpacer.height16,
                  ...financeData.specialTransactions.map(
                    (transaction) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                'in ${monthNames[transaction.month]}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Text(
                            '${transaction.isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color:
                                  transaction.isIncome
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Monthly Net Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Net',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacer.height16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Regular Monthly Income',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '\$${financeData.monthlyIncome.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                AppSpacer.height8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Regular Monthly Expenses',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '- \$${financeData.totalMonthlyExpense.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24.h, thickness: 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Cash Flow',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '\$${netMonthly.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            netMonthly >= 0
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
