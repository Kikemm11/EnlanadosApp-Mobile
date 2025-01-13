import 'package:flutter/material.dart';
import 'package:enlanados_app_mobile/widgets/widgets.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedIndex = 3;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('Statistics Screen Content'),
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
}