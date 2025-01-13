import 'package:flutter/material.dart';
import 'package:enlanados_app_mobile/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = -1;

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
          centerTitle: false, // This ensures the title is aligned to the left
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Te amo'), // Example display of the selected tab
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/splash');
          },
          child: const Text('Go to Settings'),
        ),
        bottomNavigationBar: EnlanadosNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        )
      ),
    );
  }
}
