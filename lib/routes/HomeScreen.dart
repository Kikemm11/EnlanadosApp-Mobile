import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text('EnlanadosApp'),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton (
          onPressed: () {
            Navigator.pushNamed(context, '/splash');
          },
          child: const Text('Go to Settings'),
        ),
      ),
    );
  }
}