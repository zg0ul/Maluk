import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/features/cash_flow/presentation/dialogs/expense_dialog.dart';

/// A dismissible list item for displaying and managing an expense
class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final int index;
  final Function(int index) onDelete;
  final Function(int index, Expense expense) onUpdate;

  const ExpenseItem({
    required this.expense,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('expense_${expense.name}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(index),
      child: Card(
        child: ListTile(
          title: Text(
            expense.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editExpense(context),
          ),
        ),
      ),
    );
  }

  void _editExpense(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ExpenseDialog(
            title: 'Edit Expense',
            initialExpense: expense,
            onSave: (updatedExpense) => onUpdate(index, updatedExpense),
          ),
    );
  }
}
