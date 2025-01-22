/*
This file contains the definition and functionalities of Statistics Screen

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:enlanados_app_mobile/controllers/controllers.dart';
import 'package:enlanados_app_mobile/widgets/widgets.dart';
import 'package:enlanados_app_mobile/models/Order.dart';
import 'package:enlanados_app_mobile/models/City.dart';
import 'package:enlanados_app_mobile/models/Item.dart';
import 'package:enlanados_app_mobile/models/ProductType.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _selectedIndex = 3;
  Map<String, dynamic> dateData = {};

  TextEditingController fromDateController = TextEditingController(text: '');
  TextEditingController toDateController = TextEditingController(text: '');

  // Main screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white,),
            onPressed: () {
              setState(() {
                context.read<OrderController>().cleanStatisticsData();
              });
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for Date Pickers and Search Button
              Form(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Desde',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.cyan[600],
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              dateData["fromDate"] = picked;
                              fromDateController.text =
                              "${picked.day}-${picked.month}-${picked.year}";
                            });
                          }
                        },
                        controller: fromDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecciona una fecha Desde!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Hasta',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.cyan[600],
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              dateData["toDate"] = picked;
                              toDateController.text =
                              "${picked.day}-${picked.month}-${picked.year}";
                            });
                          }
                        },
                        controller: toDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecciona una fecha Hasta!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.cyan[600],
                        size: 30.0,
                      ),
                      onPressed: (){
                        _onSearch(context);
                      },
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
              ),
              // Income info 
              Consumer<OrderController>(
                builder: (context, value, index){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pedidos: ${value.totalOrders.toString()}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Text(
                        'Total: ${value.totalIncome.toString()} \$',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                }

              ),
              // Chart Carousel
              Expanded(
                child: Consumer<OrderController>(
                  builder: (context, value, _) {
                    if (value.statisticOrders.isEmpty) {
                      return const Center(
                        child: Text('No hay datos para mostrar, amorcito!'),
                      );
                    }
                    return PageView(
                      children: [
                        // Synchronous Widget
                        _buildPaymentMethodPieChart(value.statisticOrders),

                        // Asynchronous Widgets with FutureBuilder
                        FutureBuilder<Widget>(
                          future: _buildCityPieChart(value.statisticOrders),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return snapshot.data!;
                            }
                          },
                        ),
                        FutureBuilder<Widget>(
                          future: _buildProductTypeBarChart(value.statisticOrders),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              return snapshot.data!;
                            } else {
                              return const Center(child: Text('No hay datos disponibles :('));
                            }
                            },
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: EnlanadosNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  // Screen methods

  // Manage bottom navigation var
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.read<OrderController>().cleanStatisticsData();
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

  // Validates correct dates and get the order statistics and its related income info
  Future<void> _onSearch(BuildContext context) async {
    if (dateData["fromDate"] == null || dateData["toDate"] == null ){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debes llenar las dos fechas para filtrar, tontis!'),
          backgroundColor: Colors.red,
        ),
      );
    }
    else if (dateData["toDate"].isBefore(dateData["fromDate"])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esas fechas están como raras!'),
          backgroundColor: Colors.red,
        ),
      );
    }
    else{
      await context.read<OrderController>().getStatisticsOrders(Map.from(dateData));
    }
  }


  // Build first pie chart
  Widget _buildPaymentMethodPieChart(List<Order> orderStatistics) {
    int transferenceCount = 0;
    int cashCount = 0;

    // Count the usage for each payment method
    for (Order order in orderStatistics) {
      if (order.paymentMethodId == 1) {
        transferenceCount++;
      } else if (order.paymentMethodId == 2) {
        cashCount++;
      }
    }

    int totalUsage = transferenceCount + cashCount;
    if (totalUsage == 0) totalUsage = 1;

    // Calculate percentages
    double paymentMethod1Percentage =
        (transferenceCount / totalUsage) * 100;
    double paymentMethod2Percentage =
        (cashCount / totalUsage) * 100;

    // Create the sections for the PieChart
    List<PieChartSectionData> sections = [
      PieChartSectionData(
        value: transferenceCount.toDouble(),
        title: 'Pago Móvil (Bs)\n${paymentMethod1Percentage.toStringAsFixed(1)}%',
        color: Colors.blue[300],
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        titlePositionPercentageOffset: 2.0,
          badgeWidget: Icon(Icons.money)
      ),

      PieChartSectionData(
        value: cashCount.toDouble(),
        title: 'Efectivo (\$)\n${paymentMethod2Percentage.toStringAsFixed(1)}%',
        color: Colors.green[300],
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
          titlePositionPercentageOffset: 2.0,
        badgeWidget: Icon(Icons.currency_exchange)
      ),
    ];

    // Return the PieChart widget
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
      ),
    );
  }


  // Build second pie chart
  Future<Widget> _buildCityPieChart(List<Order> orderStatistics) async {
    Map<String, int> cityData = {};
    List<PieChartSectionData> sections = [];

    // Get the count per each available city in orderStatistics
    for (Order order in orderStatistics) {
      City city = (await CityController().getOneCity(order.cityId))!;

      cityData.update(
        city.name,
            (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    int totalUsage = cityData.values.fold(0, (sum, value) => sum + value);
    if (totalUsage == 0) totalUsage = 1;

    
    // Create sections for the PieChart 
    cityData.forEach((cityName, count) {
      double percentage = (count / totalUsage) * 100;

      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$cityName\n${percentage.toStringAsFixed(1)}%',
          color: getRandomColor(),
          radius: 50.0,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          titlePositionPercentageOffset: 2.0,
        ),
      );
    });

    // Return the PieChart widget
    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        borderData: FlBorderData(show: false),
      ),
    );
  }


  // Build third chart 
  Future<Widget> _buildProductTypeBarChart(List<Order> orderStatistics) async {
    Map<String, int> productTypeData = {};

    // Gets the count of each product type related to all the order items per each order in 
    // orderStatistics
    for (Order order in orderStatistics) {
      List<Item> items = await ItemController().getOrderItemsList(order.id!);
      for (Item item in items) {
        ProductType productType = (await ProductTypeController().getOneProductType(item.productTypeId))!;
        productTypeData.update(
          productType.name,
              (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    // Return the BarchartData
    return Padding(
      padding: EdgeInsets.only(top: 20.0, right: 10.0),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Get the product name corresponding to the index
                  String title = productTypeData.keys.toList()[value.toInt()];
                  return Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                getTitlesWidget: (value, meta) {
                    String label = (value % 1 == 0) ? value.toInt().toString() : '';
                  return Text(
                      label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),

            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          barGroups: _generateBarChartGroups(productTypeData),
        ),
      ),
    );
  }


  // Generate the bar grous info per each product type 
  List<BarChartGroupData> _generateBarChartGroups(Map<String, int> productTypeData) {
    List<BarChartGroupData> barGroups = [];

    productTypeData.forEach((productType, count) {
      barGroups.add(
        BarChartGroupData(
          x: productTypeData.keys.toList().indexOf(productType),
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: count.toDouble(),
              color: getRandomColor(),
              width: 15,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    });
    return barGroups;
  }


  // Utility method to select a random color for the charts UI
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, 
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
    );
  }
}