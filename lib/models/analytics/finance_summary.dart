/// Base model untuk Finance Analytics
class FinanceSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final int transactionCount;
  final List<MonthlyFinance> monthlyData;

  FinanceSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.transactionCount,
    required this.monthlyData,
  });

  factory FinanceSummary.fromJson(Map<String, dynamic> json) {
    return FinanceSummary(
      totalIncome: (json['total_income'] ?? 0).toDouble(),
      totalExpense: (json['total_expense'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      transactionCount: json['transaction_count'] ?? 0,
      monthlyData:
          (json['monthly_data'] as List?)
              ?.map((e) => MonthlyFinance.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Mock data untuk development (12 bulan)
  factory FinanceSummary.mock() {
    return FinanceSummary(
      totalIncome: 285000000,
      totalExpense: 168000000,
      balance: 117000000,
      transactionCount: 342,
      monthlyData: [
        MonthlyFinance(month: 'Jan', income: 18000000, expense: 12000000),
        MonthlyFinance(month: 'Feb', income: 20000000, expense: 13000000),
        MonthlyFinance(month: 'Mar', income: 22000000, expense: 14000000),
        MonthlyFinance(month: 'Apr', income: 24000000, expense: 15000000),
        MonthlyFinance(month: 'Mei', income: 26000000, expense: 14500000),
        MonthlyFinance(month: 'Jun', income: 28000000, expense: 16000000),
        MonthlyFinance(month: 'Jul', income: 25000000, expense: 15000000),
        MonthlyFinance(month: 'Agu', income: 23000000, expense: 13500000),
        MonthlyFinance(month: 'Sep', income: 24000000, expense: 14000000),
        MonthlyFinance(month: 'Okt', income: 26000000, expense: 15000000),
        MonthlyFinance(month: 'Nov', income: 27000000, expense: 15000000),
        MonthlyFinance(month: 'Des', income: 22000000, expense: 11000000),
      ],
    );
  }
}

class MonthlyFinance {
  final String month;
  final double income;
  final double expense;

  MonthlyFinance({
    required this.month,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;

  factory MonthlyFinance.fromJson(Map<String, dynamic> json) {
    return MonthlyFinance(
      month: json['month'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      expense: (json['expense'] ?? 0).toDouble(),
    );
  }
}

/// Model untuk kategori pengeluaran (pie chart)
class ExpenseCategory {
  final String category;
  final double amount;
  final double percentage;

  ExpenseCategory({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<ExpenseCategory> mockData() {
    return [
      ExpenseCategory(
        category: 'Operasional',
        amount: 25000000,
        percentage: 32.1,
      ),
      ExpenseCategory(
        category: 'Kebersihan',
        amount: 18000000,
        percentage: 23.1,
      ),
      ExpenseCategory(category: 'Keamanan', amount: 15000000, percentage: 19.2),
      ExpenseCategory(
        category: 'Pemeliharaan',
        amount: 12000000,
        percentage: 15.4,
      ),
      ExpenseCategory(category: 'Lainnya', amount: 8000000, percentage: 10.2),
    ];
  }
}

/// Model untuk kategori pemasukan (pie chart)
class IncomeCategory {
  final String category;
  final double amount;
  final double percentage;

  IncomeCategory({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory IncomeCategory.fromJson(Map<String, dynamic> json) {
    return IncomeCategory(
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<IncomeCategory> mockData() {
    return [
      IncomeCategory(category: 'Iuran', amount: 65000000, percentage: 52.0),
      IncomeCategory(category: 'Donasi', amount: 30000000, percentage: 24.0),
      IncomeCategory(category: 'Penjualan', amount: 20000000, percentage: 16.0),
      IncomeCategory(category: 'Lainnya', amount: 10000000, percentage: 8.0),
    ];
  }
}
