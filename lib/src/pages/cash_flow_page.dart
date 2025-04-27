import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/common/models/finance_models.dart';
import 'package:maluk/src/providers/finance_providers.dart';
import 'package:maluk/src/utilities/app_spacer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maluk/src/widgets/custom_app_bar.dart';
import 'package:maluk/src/widgets/custom_tab_bar.dart';

class CashFlowPage extends ConsumerStatefulWidget {
  const CashFlowPage({super.key});

  @override
  ConsumerState<CashFlowPage> createState() => _CashFlowPageState();
}

class _CashFlowPageState extends ConsumerState<CashFlowPage>
    with SingleTickerProviderStateMixin {
  final _incomeController = TextEditingController();
  late final TabController _tabController;
  final _tabs = ['Overview', 'Monthly Forecast', 'Edit Expenses'];

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rebuild when tab changes
      }
    });

    // Initialize income controller with current value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final financeData = ref.read(financeDataProvider);
      _incomeController.text = financeData.monthlyIncome.toString();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final financeData = ref.watch(financeDataProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Monthly Cash Flow',
        bottom: CustomTabBar(controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Overview
          Padding(
            padding: EdgeInsets.all(16.r),
            child: _buildOverviewTab(context, financeData),
          ),

          // Tab 2: Monthly Forecast
          Padding(
            padding: EdgeInsets.all(16.r),
            child: _buildMonthlyForecastTab(context, financeData),
          ),

          // Tab 3: Edit Expenses
          Padding(
            padding: EdgeInsets.all(16.r),
            child: _buildEditExpensesTab(context, financeData),
          ),
        ],
      ),
    );
  }

  // Tab 1: Overview of current finances
  Widget _buildOverviewTab(
    BuildContext context,
    MonthlyFinanceData financeData,
  ) {
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AppSpacer.height8,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _incomeController,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            ref
                                .read(financeDataProvider.notifier)
                                .updateMonthlyIncome(double.parse(value));
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
                  style: Theme.of(context).textTheme.titleLarge,
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
                Divider(height: 24.h, thickness: 1),
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
                    style: Theme.of(context).textTheme.titleLarge,
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
                  style: Theme.of(context).textTheme.titleLarge,
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
                Divider(height: 24.h, thickness: 1),
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

  // Tab 2: Monthly forecast chart and details
  Widget _buildMonthlyForecastTab(
    BuildContext context,
    MonthlyFinanceData financeData,
  ) {
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
          style: Theme.of(context).textTheme.titleLarge,
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
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacer.width8,
                Text('Monthly Cash Flow'),
              ],
            ),
            AppSpacer.width24,
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                AppSpacer.width8,
                Text('Cumulative Balance'),
              ],
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

          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month title
                  Text(
                    monthNames[month],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (hasSpecialTransactions) ...[
                    AppSpacer.height8,
                    ...financeData.specialTransactions
                        .where((trans) => trans.month == month)
                        .map(
                          (trans) => Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Text(
                              '• ${trans.isIncome ? "Income" : "Expense"}: ${trans.name} (${trans.isIncome ? "+" : "-"}\$${trans.amount.toStringAsFixed(2)})',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
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
                      Text('Monthly Cash Flow:'),
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
                      Text('Balance:'),
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
          ).animate().fadeIn(
            duration: 300.ms,
            delay: Duration(milliseconds: 200 + (month * 50)),
          );
        }),
      ],
    );
  }

  // Tab 3: Edit expenses and add new ones
  Widget _buildEditExpensesTab(
    BuildContext context,
    MonthlyFinanceData financeData,
  ) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Regular Monthly Expenses',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        AppSpacer.height16,

        // Expense list with editing
        Expanded(
          child: ListView.builder(
            itemCount:
                financeData.monthlyExpenses.length + 1, // +1 for the "Add" card
            itemBuilder: (context, index) {
              if (index == financeData.monthlyExpenses.length) {
                // Add new expense card
                return Card(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          nameController.clear();
                          amountController.clear();

                          return AlertDialog(
                            title: const Text('Add Monthly Expense'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Expense Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                AppSpacer.height16,
                                TextField(
                                  controller: amountController,
                                  decoration: const InputDecoration(
                                    labelText: 'Amount',
                                    prefixText: '\$ ',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (nameController.text.isNotEmpty &&
                                      amountController.text.isNotEmpty) {
                                    ref
                                        .read(financeDataProvider.notifier)
                                        .addMonthlyExpense(
                                          Expense(
                                            name: nameController.text,
                                            amount: double.parse(
                                              amountController.text,
                                            ),
                                          ),
                                        );
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          AppSpacer.width16,
                          const Text('Add New Expense'),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Existing expense items
              final expense = financeData.monthlyExpenses[index];
              return Dismissible(
                key: Key('expense_${expense.name}_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(financeDataProvider.notifier)
                      .removeMonthlyExpense(index);
                },
                child: Card(
                  child: ListTile(
                    title: Text(expense.name),
                    subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            nameController.text = expense.name;
                            amountController.text = expense.amount.toString();

                            return AlertDialog(
                              title: const Text('Edit Expense'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Expense Name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  AppSpacer.height16,
                                  TextField(
                                    controller: amountController,
                                    decoration: const InputDecoration(
                                      labelText: 'Amount',
                                      prefixText: '\$ ',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (nameController.text.isNotEmpty &&
                                        amountController.text.isNotEmpty) {
                                      ref
                                          .read(financeDataProvider.notifier)
                                          .updateMonthlyExpense(
                                            index,
                                            Expense(
                                              name: nameController.text,
                                              amount: double.parse(
                                                amountController.text,
                                              ),
                                            ),
                                          );
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        AppSpacer.height24,

        // Special Transactions Section
        Text(
          'Special Transactions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        AppSpacer.height16,

        Expanded(
          child: ListView.builder(
            itemCount:
                financeData.specialTransactions.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == financeData.specialTransactions.length) {
                // Add new special transaction card
                return Card(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          nameController.clear();
                          amountController.clear();
                          int selectedMonth = 0;
                          bool isIncome = true;

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text('Add Special Transaction'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Transaction Name',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    AppSpacer.height16,
                                    TextField(
                                      controller: amountController,
                                      decoration: const InputDecoration(
                                        labelText: 'Amount',
                                        prefixText: '\$ ',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'),
                                        ),
                                      ],
                                    ),
                                    AppSpacer.height16,
                                    DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Month',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: selectedMonth,
                                      items: List.generate(
                                        12,
                                        (i) => DropdownMenuItem(
                                          value: i,
                                          child: Text(monthNames[i]),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedMonth = value!;
                                        });
                                      },
                                    ),
                                    AppSpacer.height16,
                                    Row(
                                      children: [
                                        Text(
                                          'Transaction Type:',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge,
                                        ),
                                        AppSpacer.width16,
                                        ChoiceChip(
                                          label: const Text('Income'),
                                          selected: isIncome,
                                          onSelected: (selected) {
                                            setState(() {
                                              isIncome = true;
                                            });
                                          },
                                        ),
                                        AppSpacer.width8,
                                        ChoiceChip(
                                          label: const Text('Expense'),
                                          selected: !isIncome,
                                          onSelected: (selected) {
                                            setState(() {
                                              isIncome = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (nameController.text.isNotEmpty &&
                                          amountController.text.isNotEmpty) {
                                        ref
                                            .read(financeDataProvider.notifier)
                                            .addSpecialTransaction(
                                              SpecialTransaction(
                                                name: nameController.text,
                                                amount: double.parse(
                                                  amountController.text,
                                                ),
                                                month: selectedMonth,
                                                isIncome: isIncome,
                                              ),
                                            );
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          AppSpacer.width16,
                          const Text('Add Special Transaction'),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Existing special transaction items
              final transaction = financeData.specialTransactions[index];
              return Dismissible(
                key: Key('transaction_${transaction.name}_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.w),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref
                      .read(financeDataProvider.notifier)
                      .removeSpecialTransaction(index);
                },
                child: Card(
                  child: ListTile(
                    title: Text(transaction.name),
                    subtitle: Text(
                      '${monthNames[transaction.month]} • ${transaction.isIncome ? "Income" : "Expense"} • \$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            transaction.isIncome
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Edit special transaction
                        showDialog(
                          context: context,
                          builder: (context) {
                            nameController.text = transaction.name;
                            amountController.text =
                                transaction.amount.toString();
                            int selectedMonth = transaction.month;
                            bool isIncome = transaction.isIncome;

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text('Edit Special Transaction'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Transaction Name',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      AppSpacer.height16,
                                      TextField(
                                        controller: amountController,
                                        decoration: const InputDecoration(
                                          labelText: 'Amount',
                                          prefixText: '\$ ',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}'),
                                          ),
                                        ],
                                      ),
                                      AppSpacer.height16,
                                      DropdownButtonFormField<int>(
                                        decoration: const InputDecoration(
                                          labelText: 'Month',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: selectedMonth,
                                        items: List.generate(
                                          12,
                                          (i) => DropdownMenuItem(
                                            value: i,
                                            child: Text(monthNames[i]),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMonth = value!;
                                          });
                                        },
                                      ),
                                      AppSpacer.height16,
                                      Row(
                                        children: [
                                          Text(
                                            'Transaction Type:',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge,
                                          ),
                                          AppSpacer.width16,
                                          ChoiceChip(
                                            label: const Text('Income'),
                                            selected: isIncome,
                                            onSelected: (selected) {
                                              setState(() {
                                                isIncome = true;
                                              });
                                            },
                                          ),
                                          AppSpacer.width8,
                                          ChoiceChip(
                                            label: const Text('Expense'),
                                            selected: !isIncome,
                                            onSelected: (selected) {
                                              setState(() {
                                                isIncome = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (nameController.text.isNotEmpty &&
                                            amountController.text.isNotEmpty) {
                                          ref
                                              .read(
                                                financeDataProvider.notifier,
                                              )
                                              .updateSpecialTransaction(
                                                index,
                                                SpecialTransaction(
                                                  name: nameController.text,
                                                  amount: double.parse(
                                                    amountController.text,
                                                  ),
                                                  month: selectedMonth,
                                                  isIncome: isIncome,
                                                ),
                                              );
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}
