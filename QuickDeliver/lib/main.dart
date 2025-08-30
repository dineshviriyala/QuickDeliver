import 'package:flutter/material.dart';
import 'package:your_project_name/Models/AppConstants.dart';
import 'package:your_project_name/pages/LoginPage.dart';
//import 'package:your_project_name/pages/DeliveryDetails.dart';
import 'package:your_project_name/pages/dashboardpage.dart';
import 'package:your_project_name/pages/DeliveriesPage.dart';
import 'package:your_project_name/pages/settingspage.dart';
import 'package:your_project_name/pages/splash_screen.dart';

void main() {
  runApp(const QuickDeliverApp());
}

class QuickDeliverApp extends StatelessWidget {
  const QuickDeliverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickDeliver',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/dashboard': (context) => DashboardPage(),
        '/deliveries': (context) => DeliveryStagesPage(stage: 'Assigned'),
        '/settings': (context) => SettingsPage(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
