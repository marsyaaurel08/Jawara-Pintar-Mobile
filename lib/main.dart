import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

void main() => runApp(const JawaraApp());

class JawaraApp extends StatelessWidget {
  const JawaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jawara Pintar',
      theme: buildTheme(),
      initialRoute: Routes.login,
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
