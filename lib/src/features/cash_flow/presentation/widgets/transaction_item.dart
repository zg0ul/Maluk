import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/features/cash_flow/presentation/dialogs/transaction_dialog.dart';

/// A dismissible list item for displaying and managing a special transaction
class TransactionItem extends StatelessWidget {
  final SpecialTransaction transaction;
  final int index;
  final Function(int index) onDelete;
  final Function(int index, SpecialTransaction transaction) onUpdate;
  final List<String> monthNames;

  const TransactionItem({
    required this.transaction,
    required this.index,
    required this.onDelete,
    required this.onUpdate,
    required this.monthNames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('transaction_${transaction.name}_$index'),
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
            transaction.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text(
            '${monthNames[transaction.month]} • ${transaction.isIncome ? "Income" : "Expense"} • \$${transaction.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:
                  transaction.isIncome
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTransaction(context),
          ),
        ),
      ),
    );
  }

  void _editTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => TransactionDialog(
            title: 'Edit Special Transaction',
            initialTransaction: transaction,
            onSave: (updatedTransaction) => onUpdate(index, updatedTransaction),
          ),
    );
  }
}
