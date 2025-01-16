import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/routes/routes.dart';
import 'package:enlanados_app_mobile/controllers/controllers.dart';

void main() {
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
      child: MyApp(),
    ),
  );
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
