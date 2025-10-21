import 'package:flutter/material.dart';
import '../../models/analytics/finance_summary.dart';
import '../../services/analytics_service.dart';
import '../../widgets/analytics/year_filter.dart';
import '../../widgets/analytics/finance/finance_kpi_cards.dart';
import '../../widgets/analytics/finance/finance_bar_chart.dart';
import '../../widgets/analytics/finance/finance_pie_chart.dart';

class FinanceAnalyticsPage extends StatefulWidget {
  const FinanceAnalyticsPage({super.key});

  @override
  State<FinanceAnalyticsPage> createState() => _FinanceAnalyticsPageState();
}

class _FinanceAnalyticsPageState extends State<FinanceAnalyticsPage> {
  final _service = AnalyticsService();
  bool _loading = true;
  String? _error;

  int _selectedYear = DateTime.now().year;
  FinanceSummary? _summary;
  List<IncomeCategory>? _incomeCategories;
  List<ExpenseCategory>? _expenseCategories;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        _service.fetchFinanceAnalytics(),
        _service.fetchIncomeCategories(),
        _service.fetchExpenseCategories(),
      ]);

      setState(() {
        _summary = results[0] as FinanceSummary;
        _incomeCategories = results[1] as List<IncomeCategory>;
        _expenseCategories = results[2] as List<ExpenseCategory>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onYearChanged(int year) {
    setState(() {
      _selectedYear = year;
    });
    // TODO: Fetch data for selected year
    _loadData();
  }

  // Helper method to convert income categories to chart data
  List<PieChartData> _convertIncomeToChartData(
    List<IncomeCategory>? categories,
  ) {
    if (categories == null || categories.isEmpty) return [];

    final colors = [
      const Color(0xFF10B981), // Green
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF06B6D4), // Cyan
    ];

    // Calculate total for percentage
    final total = categories.fold<double>(0, (sum, cat) => sum + cat.amount);

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      return PieChartData(
        label: category.category,
        value: category.amount,
        percentage: total > 0 ? (category.amount / total) * 100 : 0,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  // Helper method to convert expense categories to chart data
  List<PieChartData> _convertExpenseToChartData(
    List<ExpenseCategory>? categories,
  ) {
    if (categories == null || categories.isEmpty) return [];

    final colors = [
      const Color(0xFFEF4444), // Red
      const Color(0xFFF97316), // Orange
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEC4899), // Pink
    ];

    // Calculate total for percentage
    final total = categories.fold<double>(0, (sum, cat) => sum + cat.amount);

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      return PieChartData(
        label: category.category,
        value: category.amount,
        percentage: total > 0 ? (category.amount / total) * 100 : 0,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_summary == null) {
      return const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Year Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                YearFilter(
                  selectedYear: _selectedYear,
                  onYearChanged: _onYearChanged,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // KPI Cards (1 per row with modern styling)
            FinanceKpiCards(summary: _summary!),
            const SizedBox(height: 20),

            // Bar Chart: Pemasukan per Bulan (12 bulan dengan scrolling)
            FinanceBarChart(
              title: 'Pemasukan per Bulan',
              monthlyData: _summary!.monthlyData,
              barColor: const Color(0xFF10B981),
              label: 'Pemasukan',
              isIncome: true,
            ),
            const SizedBox(height: 16),

            // Bar Chart: Pengeluaran per Bulan (12 bulan dengan scrolling)
            FinanceBarChart(
              title: 'Pengeluaran per Bulan',
              monthlyData: _summary!.monthlyData,
              barColor: const Color(0xFFEF4444),
              label: 'Pengeluaran',
              isIncome: false,
            ),
            // const SizedBox(height: 16),

            // Pie Charts: Income & Expense Categories (side by side on wide screens)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 700) {
                  // Wide screen: side by side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FinancePieChart(
                          title: 'Pemasukan Berdasarkan Kategori',
                          data: _convertIncomeToChartData(_incomeCategories),
                          centerLabel: 'Pemasukan',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FinancePieChart(
                          title: 'Pengeluaran Berdasarkan Kategori',
                          data: _convertExpenseToChartData(_expenseCategories),
                          centerLabel: 'Pengeluaran',
                        ),
                      ),
                    ],
                  );
                } else {
                  // Narrow screen: stacked
                  return Column(
                    children: [
                      FinancePieChart(
                        title: 'Pemasukan Berdasarkan Kategori',
                        data: _convertIncomeToChartData(_incomeCategories),
                        centerLabel: 'Pemasukan',
                      ),
                      const SizedBox(height: 16),
                      FinancePieChart(
                        title: 'Pengeluaran Berdasarkan Kategori',
                        data: _convertExpenseToChartData(_expenseCategories),
                        centerLabel: 'Pengeluaran',
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
