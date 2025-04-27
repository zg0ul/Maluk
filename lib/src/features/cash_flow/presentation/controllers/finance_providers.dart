import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:maluk/src/features/cash_flow/domain/finance_models.dart';

part 'finance_providers.g.dart';

// Default finance data with sample values
final _defaultFinanceData = MonthlyFinanceData(
  monthlyIncome: 1200.0,
  monthlyExpenses: [
    const Expense(name: 'Rent', amount: 500.0, category: 'Housing'),
    const Expense(name: 'Grocery', amount: 300.0, category: 'Food'),
    const Expense(name: 'Gym', amount: 100.0, category: 'Health'),
  ],
  specialTransactions: [
    const SpecialTransaction(
      name: 'Yearly Bonus',
      amount: 2000.0,
      month: 6, // July (0-indexed)
      isIncome: true,
    ),
    const SpecialTransaction(
      name: 'Yearly Travel',
      amount: 1750.0,
      month: 8, // July (0-indexed)
      isIncome: false,
    ),
  ],
);

// Finance data provider
@riverpod
class FinanceData extends _$FinanceData {
  @override
  MonthlyFinanceData build() {
    return _defaultFinanceData;
  }

  // Update monthly income
  void updateMonthlyIncome(double amount) {
    state = state.copyWith(monthlyIncome: amount);
  }

  // Add monthly expense
  void addMonthlyExpense(Expense expense) {
    final newExpenses = [...state.monthlyExpenses, expense];
    state = state.copyWith(monthlyExpenses: newExpenses);
  }

  // Update monthly expense
  void updateMonthlyExpense(int index, Expense updatedExpense) {
    final expenses = [...state.monthlyExpenses];
    expenses[index] = updatedExpense;
    state = state.copyWith(monthlyExpenses: expenses);
  }

  // Remove monthly expense
  void removeMonthlyExpense(int index) {
    final expenses = [...state.monthlyExpenses];
    expenses.removeAt(index);
    state = state.copyWith(monthlyExpenses: expenses);
  }

  // Add special transaction
  void addSpecialTransaction(SpecialTransaction transaction) {
    final newTransactions = [...state.specialTransactions, transaction];
    state = state.copyWith(specialTransactions: newTransactions);
  }

  // Update special transaction
  void updateSpecialTransaction(int index, SpecialTransaction transaction) {
    final transactions = [...state.specialTransactions];
    transactions[index] = transaction;
    state = state.copyWith(specialTransactions: transactions);
  }

  // Remove special transaction
  void removeSpecialTransaction(int index) {
    final transactions = [...state.specialTransactions];
    transactions.removeAt(index);
    state = state.copyWith(specialTransactions: transactions);
  }

  // Reset to default data
  void resetData() {
    state = _defaultFinanceData;
  }
}
