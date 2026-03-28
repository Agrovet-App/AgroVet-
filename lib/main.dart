import 'package:flutter/material.dart';
import 'package:agrovet/screens/home_screen.dart';
import 'package:agrovet/screens/login_screen.dart';
import 'package:agrovet/screens/register_screen.dart';
import 'package:agrovet/utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroVet',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
