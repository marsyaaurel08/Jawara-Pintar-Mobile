/// Base model untuk Population Analytics
class PopulationSummary {
  final int totalResidents;
  final int totalHouseholds;
  final int totalHouses;
  final List<MonthlyPopulation> monthlyData;

  PopulationSummary({
    required this.totalResidents,
    required this.totalHouseholds,
    required this.totalHouses,
    required this.monthlyData,
  });

  factory PopulationSummary.fromJson(Map<String, dynamic> json) {
    return PopulationSummary(
      totalResidents: json['total_residents'] ?? 0,
      totalHouseholds: json['total_households'] ?? 0,
      totalHouses: json['total_houses'] ?? 0,
      monthlyData:
          (json['monthly_data'] as List?)
              ?.map((e) => MonthlyPopulation.fromJson(e))
              .toList() ??
          [],
    );
  }

  // Mock data untuk development
  factory PopulationSummary.mock() {
    return PopulationSummary(
      totalResidents: 5678,
      totalHouseholds: 1234,
      totalHouses: 890,
      monthlyData: [
        MonthlyPopulation(month: 'Jan', residents: 5450, households: 1180),
        MonthlyPopulation(month: 'Feb', residents: 5520, households: 1200),
        MonthlyPopulation(month: 'Mar', residents: 5590, households: 1215),
        MonthlyPopulation(month: 'Apr', residents: 5620, households: 1225),
        MonthlyPopulation(month: 'Mei', residents: 5650, households: 1230),
        MonthlyPopulation(month: 'Jun', residents: 5678, households: 1234),
      ],
    );
  }
}

class MonthlyPopulation {
  final String month;
  final int residents;
  final int households;

  MonthlyPopulation({
    required this.month,
    required this.residents,
    required this.households,
  });

  factory MonthlyPopulation.fromJson(Map<String, dynamic> json) {
    return MonthlyPopulation(
      month: json['month'] ?? '',
      residents: json['residents'] ?? 0,
      households: json['households'] ?? 0,
    );
  }
}

/// Model untuk demografi (age groups)
class AgeGroup {
  final String range;
  final int count;
  final double percentage;

  AgeGroup({
    required this.range,
    required this.count,
    required this.percentage,
  });

  factory AgeGroup.fromJson(Map<String, dynamic> json) {
    return AgeGroup(
      range: json['range'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<AgeGroup> mockData() {
    return [
      AgeGroup(range: '0-17', count: 1200, percentage: 21.1),
      AgeGroup(range: '18-30', count: 1450, percentage: 25.5),
      AgeGroup(range: '31-45', count: 1680, percentage: 29.6),
      AgeGroup(range: '46-60', count: 980, percentage: 17.3),
      AgeGroup(range: '60+', count: 368, percentage: 6.5),
    ];
  }
}

/// Model untuk gender distribution
class GenderDistribution {
  final int male;
  final int female;

  GenderDistribution({required this.male, required this.female});

  int get total => male + female;
  double get malePercentage => (male / total) * 100;
  double get femalePercentage => (female / total) * 100;

  factory GenderDistribution.fromJson(Map<String, dynamic> json) {
    return GenderDistribution(
      male: json['male'] ?? 0,
      female: json['female'] ?? 0,
    );
  }

  static GenderDistribution mockData() {
    return GenderDistribution(male: 2840, female: 2838);
  }
}

/// Model untuk status penduduk (Aktif/Non-aktif)
class ResidentStatus {
  final String status;
  final int count;
  final double percentage;

  ResidentStatus({
    required this.status,
    required this.count,
    required this.percentage,
  });

  factory ResidentStatus.fromJson(Map<String, dynamic> json) {
    return ResidentStatus(
      status: json['status'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<ResidentStatus> mockData() {
    return [
      ResidentStatus(status: 'Aktif', count: 5420, percentage: 95.5),
      ResidentStatus(status: 'Non Aktif', count: 258, percentage: 4.5),
    ];
  }
}

/// Model untuk pekerjaan penduduk
class Occupation {
  final String name;
  final int count;
  final double percentage;

  Occupation({
    required this.name,
    required this.count,
    required this.percentage,
  });

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<Occupation> mockData() {
    return [
      Occupation(name: 'Pelajar/Mahasiswa', count: 1240, percentage: 21.8),
      Occupation(name: 'Karyawan Swasta', count: 1180, percentage: 20.8),
      Occupation(name: 'Wiraswasta', count: 980, percentage: 17.3),
      Occupation(name: 'ASN', count: 720, percentage: 12.7),
      Occupation(name: 'Ibu Rumah Tangga', count: 680, percentage: 12.0),
      Occupation(name: 'Pensiunan', count: 340, percentage: 6.0),
      Occupation(name: 'Lainnya', count: 538, percentage: 9.4),
    ];
  }
}

/// Model untuk peran dalam keluarga
class FamilyRole {
  final String role;
  final int count;
  final double percentage;

  FamilyRole({
    required this.role,
    required this.count,
    required this.percentage,
  });

  factory FamilyRole.fromJson(Map<String, dynamic> json) {
    return FamilyRole(
      role: json['role'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<FamilyRole> mockData() {
    return [
      FamilyRole(role: 'Kepala Keluarga', count: 1234, percentage: 21.7),
      FamilyRole(role: 'Istri/Suami', count: 1198, percentage: 21.1),
      FamilyRole(role: 'Anak', count: 2846, percentage: 50.1),
      FamilyRole(role: 'Anggota Lain', count: 400, percentage: 7.1),
    ];
  }
}

/// Model untuk agama
class Religion {
  final String name;
  final int count;
  final double percentage;

  Religion({required this.name, required this.count, required this.percentage});

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      name: json['name'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<Religion> mockData() {
    return [
      Religion(name: 'Islam', count: 5120, percentage: 90.2),
      Religion(name: 'Kristen Protestan', count: 285, percentage: 5.0),
      Religion(name: 'Katolik', count: 142, percentage: 2.5),
      Religion(name: 'Hindu', count: 85, percentage: 1.5),
      Religion(name: 'Buddha', count: 46, percentage: 0.8),
    ];
  }
}

/// Model untuk pendidikan
class Education {
  final String level;
  final int count;
  final double percentage;

  Education({
    required this.level,
    required this.count,
    required this.percentage,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      level: json['level'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<Education> mockData() {
    return [
      Education(level: 'SD/Sederajat', count: 1420, percentage: 25.0),
      Education(level: 'SMP/Sederajat', count: 1280, percentage: 22.5),
      Education(level: 'SMA/Sederajat', count: 1640, percentage: 28.9),
      Education(level: 'D3/D4/S1', count: 980, percentage: 17.3),
      Education(level: 'S2/S3', count: 198, percentage: 3.5),
      Education(level: 'Tidak Sekolah', count: 160, percentage: 2.8),
    ];
  }
}
