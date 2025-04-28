import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/features/cash_flow/presentation/dialogs/expense_dialog.dart';
import 'package:maluk/src/features/cash_flow/presentation/dialogs/transaction_dialog.dart';
import 'package:maluk/src/features/cash_flow/presentation/widgets/expense_item.dart';
import 'package:maluk/src/features/cash_flow/presentation/widgets/transaction_item.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Tab for editing regular expenses and special transactions
class EditExpensesTab extends StatelessWidget {
  final MonthlyFinanceData financeData;
  final Function(Expense) onAddExpense;
  final Function(int) onDeleteExpense;
  final Function(int, Expense) onUpdateExpense;
  final Function(SpecialTransaction) onAddTransaction;
  final Function(int) onDeleteTransaction;
  final Function(int, SpecialTransaction) onUpdateTransaction;

  const EditExpensesTab({
    required this.financeData,
    required this.onAddExpense,
    required this.onDeleteExpense,
    required this.onUpdateExpense,
    required this.onAddTransaction,
    required this.onDeleteTransaction,
    required this.onUpdateTransaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Regular Monthly Expenses',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            GestureDetector(
              onTap: () => _showAddExpenseDialog(context),
              child: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        AppSpacer.height16,

        // Expense list with editing
        Expanded(
          child: ListView.builder(
            itemCount: financeData.monthlyExpenses.length,
            itemBuilder: (context, index) {
              // Existing expense items
              final expense = financeData.monthlyExpenses[index];
              return ExpenseItem(
                expense: expense,
                index: index,
                onDelete: onDeleteExpense,
                onUpdate: onUpdateExpense,
              );
            },
          ),
        ),

        AppSpacer.height16,

        // Special Transactions Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Special Transactions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            GestureDetector(
              onTap: () => _showAddTransactionDialog(context),
              child: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        AppSpacer.height16,

        Expanded(
          child: ListView.builder(
            itemCount: financeData.specialTransactions.length,
            itemBuilder: (context, index) {
              // Existing special transaction items
              final transaction = financeData.specialTransactions[index];
              return TransactionItem(
                transaction: transaction,
                index: index,
                onDelete: onDeleteTransaction,
                onUpdate: onUpdateTransaction,
                monthNames: monthNames,
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) =>
              ExpenseDialog(title: 'Add Monthly Expense', onSave: onAddExpense),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => TransactionDialog(
            title: 'Add Special Transaction',
            onSave: onAddTransaction,
          ),
    );
  }
}
