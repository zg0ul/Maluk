
class MonthlyFinanceData {
  final double monthlyIncome;
  final List<Expense> monthlyExpenses;
  final List<SpecialTransaction> specialTransactions;

  const MonthlyFinanceData({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.specialTransactions,
  });

  double get totalMonthlyExpense =>
      monthlyExpenses.fold(0, (sum, expense) => sum + expense.amount);

  double getMonthlyCashFlow(int month) {
    double result = monthlyIncome - totalMonthlyExpense;

    // Add special transactions for the specific month
    for (final special in specialTransactions) {
      if (special.month == month) {
        if (special.isIncome) {
          result += special.amount;
        } else {
          result -= special.amount;
        }
      }
    }

    return result;
  }

  double getMonthlyBalance(int month) {
    double balance = 0;
    for (int i = 0; i <= month; i++) {
      balance += getMonthlyCashFlow(i);
    }
    return balance;
  }

  MonthlyFinanceData copyWith({
    double? monthlyIncome,
    List<Expense>? monthlyExpenses,
    List<SpecialTransaction>? specialTransactions,
  }) {
    return MonthlyFinanceData(
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      specialTransactions: specialTransactions ?? this.specialTransactions,
    );
  }
}

class Expense {
  final String name;
  final double amount;
  final String? category;

  const Expense({required this.name, required this.amount, this.category});
}

class SpecialTransaction {
  final String name;
  final double amount;
  final int month; // 0-11 for Jan-Dec
  final bool isIncome;

  const SpecialTransaction({
    required this.name,
    required this.amount,
    required this.month,
    required this.isIncome,
  });
}


