import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Dialog for adding or editing a special transaction with improved UI
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

  // Define colors for the income/expense toggle
  final Color _expenseColor = Colors.redAccent.shade100;
  final Color _incomeColor = Colors.greenAccent.shade100;

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

  // Get appropriate icon for transaction type
  IconData get _transactionIcon =>
      _isIncome ? Icons.arrow_upward : Icons.arrow_downward;

  // Get appropriate color for transaction type
  Color get _transactionColor => _isIncome ? _incomeColor : _expenseColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(20.0.r),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with title
                Row(
                  children: [
                    Icon(_transactionIcon, color: _transactionColor),
                    AppSpacer.width8,
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                AppSpacer.height16,
                // Name input field with icon
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Transaction Name',
                    hintText: 'e.g. Bonus, Holiday Expenses',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

                // Amount input field with icon
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'e.g. 500',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}$'),
                    ),
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

                // Month dropdown with improved styling
                DropdownButtonFormField<int>(
                  value: _selectedMonth,
                  decoration: InputDecoration(
                    labelText: 'Month',
                    prefixIcon: const Icon(Icons.calendar_month),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
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

                // Income/Expense toggle redesigned
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Type',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isIncome = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      !_isIncome
                                          ? _expenseColor
                                          : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(11),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_downward,
                                      size: 18,
                                      color:
                                          !_isIncome
                                              ? Colors.red.shade700
                                              : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Expense',
                                      style: TextStyle(
                                        fontWeight:
                                            !_isIncome
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            !_isIncome
                                                ? Colors.red.shade700
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isIncome = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      _isIncome
                                          ? _incomeColor
                                          : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(11),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      size: 18,
                                      color:
                                          _isIncome
                                              ? Colors.green.shade700
                                              : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Income',
                                      style: TextStyle(
                                        fontWeight:
                                            _isIncome
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        color:
                                            _isIncome
                                                ? Colors.green.shade700
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                AppSpacer.height24,

                // Action buttons with improved styling
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saveTransaction,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
