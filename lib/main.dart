import 'package:flutter/material.dart';
import 'routes/SplashScreen.dart';
import 'package:enlanados_app_mobile/routes/HomeScreen.dart';
import 'package:enlanados_app_mobile/routes/Test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnlanadosApp',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/splash', // Set the splash screen as the initial route
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const HomeScreen(title: 'EnlanadosApp'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
