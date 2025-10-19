import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile/pages/keuangan/laporan.dart';
import 'package:jawara_pintar_mobile/pages/keuangan/pemasukan.dart';
import 'package:jawara_pintar_mobile/pages/keuangan/pengeluaran.dart';
import 'package:jawara_pintar_mobile/pages/keuangan/crud/addkeuangan.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const income = '/income';
  static const expenses = '/expenses';
  static const report = '/report';
  static const addKeuangan = '/add-keuangan';
}

final Map<String, WidgetBuilder> appRoutes = {
  Routes.login: (_) => const LoginPage(),
  Routes.register: (_) => const RegisterPage(),
  '/home': (_) => const HomePage(),
  '/income': (_) => const PemasukanPage(),
  '/expenses': (_) => const PengeluaranPage(),
  '/report': (_) => const LaporanPage(),
  Routes.addKeuangan: (ctx) {
    final arg = ModalRoute.of(ctx)?.settings.arguments;
    int idx = 0;
    if (arg is int) idx = arg;
    return AddKeuanganPage(initialIndex: idx);
  },
};
