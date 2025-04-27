import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Dialog for adding or editing a special transaction
class TransactionDialog extends StatefulWidget {
  final String title;
  final SpecialTransaction? initialTransaction;
  final Function(SpecialTransaction) onSave;

  const TransactionDialog({
    required this.title,
    required this.onSave,
    this.initialTransaction,
    super.key,
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  final _formKey = GlobalKey<FormState>();

  int _selectedMonth = 0;
  bool _isIncome = false;

  final List<String> _months = [
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

  @override
  void initState() {
    super.initState();

    // Initialize controllers with initial values if available
    _nameController = TextEditingController(
      text: widget.initialTransaction?.name ?? '',
    );
    _amountController = TextEditingController(
      text: widget.initialTransaction?.amount.toString() ?? '',
    );

    // Set initial state for month and transaction type
    if (widget.initialTransaction != null) {
      _selectedMonth = widget.initialTransaction!.month;
      _isIncome = widget.initialTransaction!.isIncome;
    }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name input field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Transaction Name',
                  hintText: 'e.g. Bonus, Holiday Expenses',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a transaction name';
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

              AppSpacer.height20,

              // Month dropdown
              DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  _months.length,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(_months[index]),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedMonth = value);
                  }
                },
              ),

              AppSpacer.height20,

              // Income/Expense toggle
              Row(
                children: [
                  Text(
                    'Transaction Type:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  AppSpacer.width16,
                  ChoiceChip(
                    label: const Text('Expense'),
                    selected: !_isIncome,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _isIncome = false);
                      }
                    },
                  ),
                  AppSpacer.width8,
                  ChoiceChip(
                    label: const Text('Income'),
                    selected: _isIncome,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _isIncome = true);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveTransaction, child: const Text('Save')),
      ],
    );
  }

  void _saveTransaction() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text);

      final transaction = SpecialTransaction(
        name: name,
        amount: amount,
        month: _selectedMonth,
        isIncome: _isIncome,
      );

      widget.onSave(transaction);
      Navigator.of(context).pop();
    }
  }
}
