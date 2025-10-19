import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/kegiatan_page.dart';
import 'pages/broadcast_page.dart';
import 'pages/aspirasi_page.dart';
import 'pages/user_management_screen.dart';
import 'pages/activity_log_screen.dart';
import 'pages/resident_approvals_screen.dart';
import 'pages/family_mutation_screen.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const String home = '/home';

  static const String kegiatan = '/kegiatan';
  static const String broadcast = '/broadcast';
  static const String aspirasi = '/aspirasi';
  static const String pengguna = '/manajemen_pengguna';
  static const String activityLog = '/activity_log';
  static const String approvals = '/approvals';
  static const String mutations = '/mutations';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.login: (_) => const LoginPage(),
  Routes.register: (_) => const RegisterPage(),
  Routes.home: (_) => const HomePage(),
  Routes.kegiatan: (_) => const KegiatanPage(),
  Routes.broadcast: (_) => const BroadcastPage(),
  Routes.aspirasi: (_) => const AspirasiPage(),
  Routes.pengguna: (_) => const UserManagementScreen(),
  Routes.activityLog: (_) => const ActivityLogScreen(),
  Routes.approvals: (_) => const ResidentApprovalsScreen(),
  Routes.mutations: (_) => const FamilyMutationScreen(),
};
