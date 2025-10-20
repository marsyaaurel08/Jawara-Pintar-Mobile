import '../models/analytics/finance_summary.dart';
import '../models/analytics/activities_summary.dart';
import '../models/analytics/population_summary.dart';

/// Analytics Service
/// Handles all analytics data fetching
/// TODO: Replace mock data with real API calls
class AnalyticsService {
  // Singleton pattern untuk easy access
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// Fetch Finance Analytics
  ///
  /// Backend endpoint: GET /api/analytics/finance
  /// Query params: ?start_date=...&end_date=...
  Future<FinanceSummary> fetchFinanceAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // TODO: Implement real API call
    // Example:
    // final response = await http.get(
    //   Uri.parse('$baseUrl/api/analytics/finance')
    //     .replace(queryParameters: {
    //       'start_date': startDate?.toIso8601String(),
    //       'end_date': endDate?.toIso8601String(),
    //     }),
    //   headers: {'Authorization': 'Bearer $token'},
    // );
    // if (response.statusCode == 200) {
    //   return FinanceSummary.fromJson(jsonDecode(response.body));
    // }
    // throw Exception('Failed to load finance analytics');

    // Mock delay to simulate network
    await Future.delayed(const Duration(milliseconds: 800));
    return FinanceSummary.mock();
  }

  /// Fetch expense categories for pie chart
  Future<List<ExpenseCategory>> fetchExpenseCategories() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ExpenseCategory.mockData();
  }

  /// Fetch income categories for pie chart
  Future<List<IncomeCategory>> fetchIncomeCategories() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return IncomeCategory.mockData();
  }

  /// Fetch Activities Analytics
  ///
  /// Backend endpoint: GET /api/analytics/activities
  Future<ActivitiesSummary> fetchActivitiesAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // TODO: Implement real API call
    await Future.delayed(const Duration(milliseconds: 800));
    return ActivitiesSummary.mock();
  }

  /// Fetch activity types distribution
  Future<List<ActivityType>> fetchActivityTypes() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ActivityType.mockData();
  }

  /// Fetch responsible persons (penanggung jawab)
  Future<List<ResponsiblePerson>> fetchResponsiblePersons() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ResponsiblePerson.mockData();
  }

  /// Fetch Population Analytics
  ///
  /// Backend endpoint: GET /api/analytics/population
  Future<PopulationSummary> fetchPopulationAnalytics() async {
    // TODO: Implement real API call
    await Future.delayed(const Duration(milliseconds: 800));
    return PopulationSummary.mock();
  }

  /// Fetch age group distribution
  Future<List<AgeGroup>> fetchAgeGroups() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return AgeGroup.mockData();
  }

  /// Fetch gender distribution
  Future<GenderDistribution> fetchGenderDistribution() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return GenderDistribution.mockData();
  }

  /// Fetch resident status (Aktif/Non-aktif)
  Future<List<ResidentStatus>> fetchResidentStatus() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ResidentStatus.mockData();
  }

  /// Fetch occupations (pekerjaan)
  Future<List<Occupation>> fetchOccupations() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Occupation.mockData();
  }

  /// Fetch family roles (peran dalam keluarga)
  Future<List<FamilyRole>> fetchFamilyRoles() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return FamilyRole.mockData();
  }

  /// Fetch religions (agama)
  Future<List<Religion>> fetchReligions() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Religion.mockData();
  }

  /// Fetch education levels (pendidikan)
  Future<List<Education>> fetchEducationLevels() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Education.mockData();
  }
}
