/*
This file contains the definition and functionalities of WoolStock Screen

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:enlanados_app_mobile/widgets/EnlanadosWoolStockSearch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/widgets/widgets.dart';
import 'package:enlanados_app_mobile/models/WoolStock.dart';
import 'package:enlanados_app_mobile/controllers/WoolStockController.dart';


class WoolStockScreen extends StatefulWidget {
  const WoolStockScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WoolStockScreenState createState() => _WoolStockScreenState();
}

class _WoolStockScreenState extends State<WoolStockScreen> {
  int _selectedIndex = 2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Fetch wools for initial state
  @override
  void initState() {
    super.initState();
    _fetchWoolStocks();
  }

  Future<void> _fetchWoolStocks() async {
    await context.read<WoolStockController>().getAllWoolStocks();
    setState(() {
    });
  }


  // Main screen
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
          actions: [
            Consumer<WoolStockController>(
              builder: (context, value, child){
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: EnlanadosWoolStockSearch(value.woolStock),
                    );
                  },
                );
              }
            ),
          ],
        ),
        body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Consumer<WoolStockController>(
                  builder: (context, value, child) {
                    // Wools list
                    return ListView.builder(
                      itemCount: value.woolStock.length,
                      itemBuilder: (context, index) {
                        WoolStock woolStock = value.woolStock[index];
                        return Dismissible(
                          key: Key(woolStock.id.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog before dismissing
                            bool shouldDelete = await _showDeleteConfirmationDialog(woolStock);

                            return shouldDelete; // Only dismiss the card if the user confirmed the deletion
                          },
                          onDismissed: (direction) async {
                            String result = await context.read<WoolStockController>().deleteWoolStock(woolStock);

                            if (result == 'Ok') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Lana eliminada!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al eliminar el producto'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          background: Container(
                            color: Colors.red,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Icon(Icons.delete, color: Colors.grey),
                              ),
                            ),
                          ),
                          // Wool Stock card info
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            elevation: 8.0,
                            color: Colors.green[50],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget> [
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  leading: Icon(Icons.inventory, color: Colors.green[200]),
                                  title: Row(
                                      children: <Widget> [
                                        Text(
                                          woolStock.color,
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.orange[600],
                                            size: 17.0,
                                          ),
                                          onPressed: () {
                                            _showEditWoolStockFormDialog(woolStock);
                                          },
                                        ),
                                      ]
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.orange[600],
                                        ),
                                        onPressed: () async {
                                          await context.read<WoolStockController>().decrementWoolStock(woolStock);
                                        },
                                      ),
                                      Text(
                                        woolStock.quantity.toString(),
                                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.orange[600],
                                        ),
                                        onPressed: () async {
                                          await context.read<WoolStockController>().incrementWoolStock(woolStock);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0, bottom: 5.0),
                                  child: Text(
                                    "Actualizado: ${woolStock.lastUpdated.day}/${woolStock.lastUpdated.month}/${woolStock.lastUpdated.year}", // Format the date
                                    style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400),
                                  ),
                                ),
                             ]
                            ),
                          ),
                        );
                      },
                    );
                  }
              ),
            )
        ),
        // Creates a new wool stock
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreateWoolStockFormDialog,
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


  // Screen methods

  // Manage the bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);

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

  // Dialog create WoolStock
  void _showCreateWoolStockFormDialog() {

    String color = '';
    String quantity = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nueva Lana'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Color'),
                    onSaved: (value) {
                      color = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un color, amorcito!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      quantity = value ?? '0';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce una cantidad, amorcito!';
                      }
                      if (int.tryParse(value)! < 0) {
                        return 'La cantidad no puede ser negativa,\ncielo!';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  WoolStock woolStock = WoolStock(color: color, quantity: int.tryParse(quantity)!);
                  String result = await context.read<WoolStockController>().insertWoolStock(woolStock);

                  if (result != 'Ok'){

                    String message = 'Ups, ha ocurrido un error creando el nuevo inventario de lana!';

                    if (result == 'UNIQUE'){ message = 'Ese color de lana ya existe, tontita!'; }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Inventario de lana creado!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.green),
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }


  // Dialog edit WoolStock
  void _showEditWoolStockFormDialog(WoolStock woolStock) {
    TextEditingController colorController = TextEditingController(text: woolStock.color);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Lana'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: colorController,
                    decoration: const InputDecoration(labelText: 'Color'),
                    onSaved: (value) {
                      woolStock.color = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un color, amorcito!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.red),
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  String result = await context.read<WoolStockController>().updateWoolStock(woolStock);

                  if (result != 'Ok') {
                    String message = 'Ups, ha ocurrido un error actualizando la lana!';
                    if (result == 'UNIQUE') {
                      message = 'Ese color de lana ya existe, tontita!';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lana actualizada!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.green),
              ),
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }


  // Dialog confirm delete WoolStock
  Future<bool> _showDeleteConfirmationDialog(WoolStock woolStock) async {
    String woolStockColor = woolStock.color;
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar la lana "$woolStockColor"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels deletion
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms deletion
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    // Return true if the user confirmed the deletion, false otherwise
    return shouldDelete ?? false;
  }
}