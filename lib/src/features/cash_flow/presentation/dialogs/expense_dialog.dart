import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Dialog for adding or editing an expense
class ExpenseDialog extends StatefulWidget {
  final String title;
  final Expense? initialExpense;
  final Function(Expense) onSave;

  const ExpenseDialog({
    required this.title,
    required this.onSave,
    this.initialExpense,
    super.key,
  });

  @override
  State<ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialExpense?.name ?? '',
    );
    _amountController = TextEditingController(
      text: widget.initialExpense?.amount.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name input field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Expense Name',
                hintText: 'e.g. Rent, Groceries',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an expense name';
                }
                return null;
              },
            ),

            AppSpacer.height16,

            // Amount input field
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (\$)',
                hintText: 'e.g. 500',
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveExpense, child: const Text('Save')),
      ],
    );
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text);

      final expense = Expense(name: name, amount: amount);

      widget.onSave(expense);
      Navigator.of(context).pop();
    }
  }
}
