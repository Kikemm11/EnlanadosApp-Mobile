/*
This file contains the flutterbinding initialization, routes definition,
providers definition and serves as the app entry point

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:enlanados_app_mobile/routes/routes.dart';
import 'package:enlanados_app_mobile/controllers/controllers.dart';
import 'package:enlanados_app_mobile/notifications/NotificationService.dart';


// Flutter Binding and  Multiprovider configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CityController()),
        ChangeNotifierProvider(create: (context) => OrderController()),
        ChangeNotifierProvider(create: (context) => ItemController()),
        ChangeNotifierProvider(create: (context) => PaymentMethodController()),
        ChangeNotifierProvider(create: (context) => StatusController()),
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (context) => ProductTypeController()),
        ChangeNotifierProvider(create: (context) => WoolStockController()),
      ],
      child: EnlanadosApp(),
    ),
  );
}

// Main class
class EnlanadosApp extends StatelessWidget {
  const EnlanadosApp({super.key});

  // Routes definition and main config
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnlanadosApp',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const HomeScreen(title: 'EnlanadosApp'),
        '/orders': (context) => const OrderScreen(title: 'Pedidos'),
        '/create-order': (context) => const CreateOrderScreen(title: 'Nuevo Pedido'),
        '/order-detail': (context) => const OrderDetailScreen(title: 'Detalle de Pedido'),
        '/products': (context) => const ProductScreen(title: 'Productos'),
        '/product-types': (context) => const ProductTypeScreen(title: 'Tipos de Productos'),
        '/wool-stock': (context) => const WoolStockScreen(title: 'Inventario'),
        '/statistics': (context) => const StatisticsScreen(title: 'Estadísticas'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}