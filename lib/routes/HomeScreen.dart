import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/widgets/widgets.dart';
import 'package:enlanados_app_mobile/controllers/controllers.dart';
import 'package:enlanados_app_mobile/models/Order.dart';
import 'package:enlanados_app_mobile/models/City.dart';


import 'package:enlanados_app_mobile/notifications/NotificationService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = -1;
  bool _showHeart = false;

  // Fetch current month with pending status orders for initial state
  @override
  void initState() {
    super.initState();
    _fetchCurrentMonthWithStatusOrders();

    DateTime now = DateTime.now();

    if ([18, 23, 4].contains(now.day)){
      NotificationService.showInstantNotification(
        "Hola, enlanatrabajadora 🐰!",
        "Paso por acá para decirte que lo estás haciendo asombroso, te amu.",
      );
    }

  }

  Future<void> _fetchCurrentMonthWithStatusOrders() async {
    await context.read<OrderController>().getCurrentMonthWhitStatusOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[600],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/assets/logo.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 8),
              // Title
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: TextButton(
                onPressed: showHeartOverlay,
                child: Text(
                  'Te amo!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          ],
          centerTitle: false, // This ensures the title is aligned to the left
        ),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'lib/assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Foreground content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Consumer<OrderController>(
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Icon(
                            Icons.warning, // Exclamation mark icon
                            color: Colors.orange[600],
                            size: 50.0, // Adjust size as needed
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.ordersHome.length,
                            itemBuilder: (context, index) {
                              Order order = value.ordersHome[index];
                              return FutureBuilder<List<dynamic>>(
                                future: Future.wait([
                                  context.read<ItemController>().getOrderTotalIncome(order),
                                  context.read<CityController>().getOneCity(order.cityId),
                                ]),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || snapshot.data == null) {
                                    return Card(
                                      color: Colors.white,
                                    );
                                  }

                                  double orderTotalIncome = snapshot.data![0];
                                  City orderCity = snapshot.data![1];

                                  return Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                    elevation: 8.0,
                                    color: Colors.green[50],
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                      onLongPress: () {
                                        _showOrderActionBottomSheet(context, order);
                                      },
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/order-detail',
                                          arguments: {'order': order},
                                        ).then((_) {
                                          setState(() {
                                            _fetchCurrentMonthWithStatusOrders();
                                          });
                                        });
                                      },
                                      leading: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            order.id.toString(),
                                            style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
                                          ),
                                          Icon(Icons.list_alt, color: Colors.green[200], size: 20.0),
                                        ],
                                      ),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.person, color: Colors.cyan[600], size: 16.0),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        order.client,
                                                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_city, color: Colors.cyan[600], size: 16.0),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        orderCity.name,
                                                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.arrow_forward, color: Colors.cyan[600], size: 16.0),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        'Total: ${orderTotalIncome.toStringAsFixed(2)} \$',
                                                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.attach_money, color: Colors.cyan[600], size: 16.0),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        'Abono: ${order.credit.toStringAsFixed(2)} \$',
                                                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.calendar_today, color: Colors.cyan[600], size: 16.0),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                '${order.estimatedDate.day.toString()}/${order.estimatedDate.month.toString()}/${order.estimatedDate.year.toString()}',
                                                style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (_showHeart)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.deepOrangeAccent,
                              size: 150.0, // Adjust size as needed
                            ),
                          ),
                          Text(
                            'Lo estás haciendo espectacular, estoy orgulloso de ti',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Colors.white
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
          ],
        ),
        bottomNavigationBar: EnlanadosNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        )
      ),
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective screen based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/orders', arguments: {"index": _selectedIndex});
        _selectedIndex = -1;
        break;
      case 1:
        Navigator.pushNamed(context, '/products', arguments: {"index": _selectedIndex});
        _selectedIndex = -1;
        break;
      case 2:
        Navigator.pushNamed(context, '/wool-stock', arguments: {"index": _selectedIndex});
        _selectedIndex = -1;
        break;
      case 3:
        Navigator.pushNamed(context, '/statistics', arguments: {"index": _selectedIndex});
        _selectedIndex = -1;
        break;
    }
  }


  void _showOrderActionBottomSheet(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '¿Qué deseas hacer con el pedido?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons horizontally
                children: [
                  TextButton(
                    child: Text('Entregar'),
                    onPressed: () {
                      if (order.statusId == 1){
                        OrderController().deliverOrder(order);
                      }
                      setState(() {
                        _fetchCurrentMonthWithStatusOrders();
                      });
                      Navigator.of(context).pop();
                      // Add your delivery logic here
                    },
                  ),
                  SizedBox(width: 10), // Optional: Add some space between buttons
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      if (order.statusId == 1){
                        OrderController().cancelOrder(order);
                      }
                      setState(() {
                        _fetchCurrentMonthWithStatusOrders();
                      });
                      Navigator.of(context).pop();
                      // Add your cancellation logic here
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showHeartOverlay() {
    setState(() {
      _showHeart = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showHeart = false;
      });
    });
  }


}
