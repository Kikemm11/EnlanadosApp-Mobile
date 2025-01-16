import 'package:enlanados_app_mobile/models/City.dart';
import 'package:enlanados_app_mobile/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/widgets/widgets.dart';
import 'package:enlanados_app_mobile/controllers/controllers.dart';
import 'package:enlanados_app_mobile/models/Order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 0;

  IconData? currencyIcon;
  IconData? statusIcon;
  Color statusIconColor = Colors.orange;


  // Fetch current month orders for initial state
  @override
  void initState() {
    super.initState();
    _fetchCurrentMonthOrders();
  }

  Future<void> _fetchCurrentMonthOrders() async {
    await context.read<OrderController>().getCurrentMonthOrders();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white,),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,);
            },
          ),
          backgroundColor: Colors.cyan[600],
          title: Text(widget.title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Consumer<OrderController>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: value.orders.length,
                      itemBuilder: (context, index) {
                        Order order = value.orders[index];
                        return FutureBuilder<List<dynamic>>(
                          future: Future.wait([
                            context.read<ItemController>().getOrderTotalIncome(order),
                            context.read<CityController>().getOneCity(order.cityId),
                            context.read<PaymentMethodController>().getOnePaymentMethod(order.paymentMethodId),
                            context.read<StatusController>().getOneStatus(order.statusId),
                          ]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 1.0,
                                color: Colors.cyan[50],
                                child: ListTile(
                                  title: Text('Loading...'),
                                ),
                              );
                            }

                            double orderTotalIncome = snapshot.data![0];
                            City orderCity = snapshot.data![1];
                            PaymentMethod orderPaymentMethod = snapshot.data![2];
                            Status orderStatus = snapshot.data![3];

                            if (orderPaymentMethod.id == 1){
                              currencyIcon = Icons.currency_exchange;
                            }
                            else{
                              currencyIcon = Icons.money;
                            }

                            switch (orderStatus.id){
                              case 1:
                                statusIcon = Icons.info;
                                statusIconColor = Colors.orange;
                                break;
                              case 2:
                                statusIcon = Icons.check_circle_outline;
                                statusIconColor = Colors.green;
                                break;
                              case 3:
                                statusIcon = Icons.cancel;
                                statusIconColor = Colors.red;
                                break;
                            }

                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              elevation: 8.0,
                              color: Colors.green[50],
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                onLongPress: (){
                                  _showOrderActionBottomSheet(context, order);
                                },
                                onTap: (){
                                  Navigator.pushNamed(
                                    context,
                                    '/order-detail',
                                    arguments: {'order': order},
                                  ).then((_){
                                    setState(() {
                                      _fetchCurrentMonthOrders();
                                    });
                                  });
                                },
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      order.id.toString(),
                                      style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
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
                                        // Left Column: Client and Order Status
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person, color: Colors.cyan[600], size: 16.0),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  order.client,
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.0),
                                            Row(
                                              children: [
                                                Icon(Icons.location_city, color: Colors.cyan[600], size: 16.0),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  orderCity.name,
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Right Column: City and Total
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15.0),
                                              child: Row(
                                                children: [
                                                  Icon(currencyIcon, color: Colors.cyan[600], size: 16.0),
                                                  SizedBox(width: 5.0),
                                                  Text(
                                                    orderPaymentMethod.name,
                                                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.arrow_forward, color: Colors.cyan[600], size: 16.0),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  'Total: ${orderTotalIncome.toStringAsFixed(2)} \$',
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.0),
                                    // Centered Row for Payment Method and Estimated Date
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(statusIcon, color: statusIconColor, size: 16.0),
                                        SizedBox(width: 5.0),
                                        Text(
                                          orderStatus.name,
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(width: 15.0),
                                        Icon(Icons.calendar_today, color: Colors.cyan[600], size: 16.0),
                                        SizedBox(width: 5.0),
                                        Text(
                                          '${order.estimatedDate.day.toString()}/${order.estimatedDate.month.toString()}/${order.estimatedDate.year.toString()}',
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );


                          },
                        );
                      }
                        );
                  }
              ),
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, '/create-order').then((_){
              setState(() {
                _fetchCurrentMonthOrders();
              });
            });
          },
          backgroundColor: Colors.orange[100],
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: EnlanadosNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    // Navigate to the respective screen based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/orders', arguments: {"index": _selectedIndex});
        break;
      case 1:
        Navigator.pushNamed(context, '/products', arguments: {"index": _selectedIndex});
        break;
      case 2:
        Navigator.pushNamed(context, '/wool-stock', arguments: {"index": _selectedIndex});
        break;
      case 3:
        Navigator.pushNamed(context, '/statistics', arguments: {"index": _selectedIndex});
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
                        _fetchCurrentMonthOrders();
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
                        _fetchCurrentMonthOrders();
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


}