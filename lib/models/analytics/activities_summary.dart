/// Base model untuk Activities Analytics
class ActivitiesSummary {
  final int totalActivities;
  final int totalParticipants;
  final double averageAttendance;
  final List<MonthlyActivity> monthlyData;
  final int pastActivities;
  final int todayActivities;
  final int upcomingActivities;

  ActivitiesSummary({
    required this.totalActivities,
    required this.totalParticipants,
    required this.averageAttendance,
    required this.monthlyData,
    this.pastActivities = 0,
    this.todayActivities = 0,
    this.upcomingActivities = 0,
  });

  factory ActivitiesSummary.fromJson(Map<String, dynamic> json) {
    return ActivitiesSummary(
      totalActivities: json['total_activities'] ?? 0,
      totalParticipants: json['total_participants'] ?? 0,
      averageAttendance: (json['average_attendance'] ?? 0).toDouble(),
      monthlyData:
          (json['monthly_data'] as List?)
              ?.map((e) => MonthlyActivity.fromJson(e))
              .toList() ??
          [],
      pastActivities: json['past_activities'] ?? 0,
      todayActivities: json['today_activities'] ?? 0,
      upcomingActivities: json['upcoming_activities'] ?? 0,
    );
  }

  // Mock data untuk development
  factory ActivitiesSummary.mock() {
    return ActivitiesSummary(
      totalActivities: 24,
      totalParticipants: 1234,
      averageAttendance: 51.4,
      pastActivities: 45,
      todayActivities: 5,
      upcomingActivities: 15,
      monthlyData: [
        MonthlyActivity(month: 'Jan', count: 3, participants: 180),
        MonthlyActivity(month: 'Feb', count: 4, participants: 220),
        MonthlyActivity(month: 'Mar', count: 5, participants: 280),
        MonthlyActivity(month: 'Apr', count: 4, participants: 210),
        MonthlyActivity(month: 'Mei', count: 3, participants: 160),
        MonthlyActivity(month: 'Jun', count: 5, participants: 184),
        MonthlyActivity(month: 'Jul', count: 6, participants: 240),
        MonthlyActivity(month: 'Ags', count: 4, participants: 195),
        MonthlyActivity(month: 'Sep', count: 5, participants: 215),
        MonthlyActivity(month: 'Okt', count: 7, participants: 280),
        MonthlyActivity(month: 'Nov', count: 3, participants: 150),
        MonthlyActivity(month: 'Des', count: 4, participants: 175),
      ],
    );
  }
}

class MonthlyActivity {
  final String month;
  final int count;
  final int participants;

  MonthlyActivity({
    required this.month,
    required this.count,
    required this.participants,
  });

  double get avgParticipants => count > 0 ? participants / count : 0;

  factory MonthlyActivity.fromJson(Map<String, dynamic> json) {
    return MonthlyActivity(
      month: json['month'] ?? '',
      count: json['count'] ?? 0,
      participants: json['participants'] ?? 0,
    );
  }
}

/// Model untuk tipe kegiatan
class ActivityType {
  final String type;
  final int count;
  final double percentage;

  ActivityType({
    required this.type,
    required this.count,
    required this.percentage,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  static List<ActivityType> mockData() {
    return [
      ActivityType(type: 'Komunitas & Sosial', count: 12, percentage: 28.6),
      ActivityType(type: 'Kebersihan & Keamanan', count: 10, percentage: 23.8),
      ActivityType(type: 'Keagamaan', count: 8, percentage: 19.0),
      ActivityType(type: 'Pendidikan', count: 6, percentage: 14.3),
      ActivityType(type: 'Kesehatan & Olahraga', count: 4, percentage: 9.5),
      ActivityType(type: 'Lainnya', count: 2, percentage: 4.8),
    ];
  }
}

/// Model untuk penanggung jawab kegiatan
class ResponsiblePerson {
  final String name;
  final int activitiesCount;

  ResponsiblePerson({required this.name, required this.activitiesCount});

  factory ResponsiblePerson.fromJson(Map<String, dynamic> json) {
    return ResponsiblePerson(
      name: json['name'] ?? '',
      activitiesCount: json['activities_count'] ?? 0,
    );
  }

  static List<ResponsiblePerson> mockData() {
    return [
      ResponsiblePerson(name: 'Ahmad Yani', activitiesCount: 12),
      ResponsiblePerson(name: 'Siti Nurhaliza', activitiesCount: 10),
      ResponsiblePerson(name: 'Budi Santoso', activitiesCount: 9),
      ResponsiblePerson(name: 'Dewi Lestari', activitiesCount: 8),
      ResponsiblePerson(name: 'Eko Prasetyo', activitiesCount: 7),
      ResponsiblePerson(name: 'Fitri Handayani', activitiesCount: 6),
      ResponsiblePerson(name: 'Galih Pratama', activitiesCount: 5),
      ResponsiblePerson(name: 'Hana Wijaya', activitiesCount: 4),
      ResponsiblePerson(name: 'Irfan Hakim', activitiesCount: 4),
      ResponsiblePerson(name: 'Joko Widodo', activitiesCount: 3),
      ResponsiblePerson(name: 'Kartika Sari', activitiesCount: 3),
      ResponsiblePerson(name: 'Linda Maulida', activitiesCount: 2),
    ];
  }
}
