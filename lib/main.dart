import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const FloodRiskApp());
}

class FloodRiskApp extends StatelessWidget {
  const FloodRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flood Risk App',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      // ROUTES
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const Placeholder(), // Tidak digunakan
      },
    );
  }
}
