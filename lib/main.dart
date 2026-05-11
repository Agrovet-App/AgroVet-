import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:agrovet/screens/role_selection_screen.dart';
import 'package:agrovet/screens/account_type_selection_screen.dart';
import 'package:agrovet/screens/login_farmer_screen.dart';
import 'package:agrovet/screens/login_veterinarian_screen.dart';
import 'package:agrovet/screens/register_farmer_screen.dart';
import 'package:agrovet/screens/register_veterinarian_screen.dart';
import 'package:agrovet/screens/register_screen.dart';
import 'package:agrovet/screens/home_screen.dart';
import 'package:agrovet/screens/home_farmer_screen.dart';
import 'package:agrovet/screens/home_veterinarian_screen.dart';
import 'package:agrovet/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroVet',
      theme: AppTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),
        '/account_type_login': (context) => const AccountTypeSelectionScreen(action: 'login'),
        '/account_type_register': (context) => const AccountTypeSelectionScreen(action: 'register'),
        '/login_farmer': (context) => const LoginFarmerScreen(),
        '/login_veterinarian': (context) => const LoginVeterinarianScreen(),
        '/register': (context) => const RegisterScreen(),
        '/register_farmer': (context) => const RegisterFarmerScreen(),
        '/register_veterinarian': (context) => const RegisterVeterinarianScreen(),
        '/home': (context) => const HomeScreen(),
        '/home_farmer': (context) => const HomeFarmerScreen(),
        '/home_veterinarian': (context) => const HomeVeterinarianScreen(),
      },
    );
  }
}
