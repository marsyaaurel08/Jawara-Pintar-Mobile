import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/kegiatan_page.dart';
import 'pages/broadcast_page.dart';
import 'pages/aspirasi_page.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';

  static const String kegiatan = '/kegiatan';
  static const String broadcast = '/broadcast';
  static const String aspirasi = '/aspirasi';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.login: (_) => const LoginPage(),
  Routes.register: (_) => const RegisterPage(),
  '/home': (_) => const HomePage(),
  Routes.kegiatan: (_) => const KegiatanPage(),
  Routes.broadcast: (_) => const BroadcastPage(),
  Routes.aspirasi: (_) => const AspirasiPage(),
};
