import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/features/cash_flow/presentation/views/edit_expenses_tab.dart';
import 'package:maluk/src/features/cash_flow/presentation/views/forecast_tab.dart';
import 'package:maluk/src/features/cash_flow/presentation/views/overview_tab.dart';
import 'package:maluk/src/features/cash_flow/presentation/controllers/finance_providers.dart';
import 'package:maluk/src/common/widgets/custom_app_bar.dart';
import 'package:maluk/src/common/widgets/custom_tab_bar.dart';

/// Cash Flow Page displays financial overview, forecasts and expense management
class CashFlowPage extends ConsumerStatefulWidget {
  const CashFlowPage({super.key});

  @override
  ConsumerState<CashFlowPage> createState() => _CashFlowPageState();
}

class _CashFlowPageState extends ConsumerState<CashFlowPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _incomeController;
  final _tabs = ['Overview', 'Monthly Forecast', 'Edit Expenses'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rebuild when tab changes
      }
    });

    _incomeController = TextEditingController();

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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Scaffold(
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
              child: OverviewTab(
                financeData: financeData,
                incomeController: _incomeController,
                onIncomeChanged: _handleIncomeChanged,
              ),
            ),

            // Tab 2: Monthly Forecast
            Padding(
              padding: EdgeInsets.all(16.r),
              child: ForecastTab(financeData: financeData),
            ),

            // Tab 3: Edit Expenses
            Padding(
              padding: EdgeInsets.all(16.r),
              child: EditExpensesTab(
                financeData: financeData,
                onAddExpense: _handleAddExpense,
                onDeleteExpense: _handleDeleteExpense,
                onUpdateExpense: _handleUpdateExpense,
                onAddTransaction: _handleAddTransaction,
                onDeleteTransaction: _handleDeleteTransaction,
                onUpdateTransaction: _handleUpdateTransaction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Income management
  void _handleIncomeChanged(double value) {
    ref.read(financeDataProvider.notifier).updateMonthlyIncome(value);
  }

  // Expense management
  void _handleAddExpense(Expense expense) {
    ref.read(financeDataProvider.notifier).addMonthlyExpense(expense);
  }

  void _handleDeleteExpense(int index) {
    ref.read(financeDataProvider.notifier).removeMonthlyExpense(index);
  }

  void _handleUpdateExpense(int index, Expense expense) {
    ref.read(financeDataProvider.notifier).updateMonthlyExpense(index, expense);
  }

  // Transaction management
  void _handleAddTransaction(SpecialTransaction transaction) {
    ref.read(financeDataProvider.notifier).addSpecialTransaction(transaction);
  }

  void _handleDeleteTransaction(int index) {
    ref.read(financeDataProvider.notifier).removeSpecialTransaction(index);
  }

  void _handleUpdateTransaction(int index, SpecialTransaction transaction) {
    ref
        .read(financeDataProvider.notifier)
        .updateSpecialTransaction(index, transaction);
  }
}
