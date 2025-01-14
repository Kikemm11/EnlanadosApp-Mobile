import 'package:flutter/material.dart';
import 'package:enlanados_app_mobile/models/WoolStock.dart';
import 'package:enlanados_app_mobile/controllers/WoolStockController.dart';
import 'package:provider/provider.dart';

class EnlanadosWoolStockSearch extends SearchDelegate {
  final List<dynamic> data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EnlanadosWoolStockSearch(this.data);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data.where((item) => item.color.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].color),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data.where((item) => item.color.toLowerCase().contains(query.toLowerCase())).toList();


    // Dialog edit WoolStock

    void _showEditWoolStockFormDialog(WoolStock woolStock) {
      // Controllers for text fields
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
                  Navigator.pop(context); // Close the dialog
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

    // Dialog confirm delete Product

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

    return Consumer<WoolStockController>(
      builder: (context, value, child){
        return Container(
          color: Colors.cyan[300],
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              WoolStock woolStock = suggestions[index];
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
                    suggestions.remove(woolStock);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto eliminado!'),
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
                  color: Colors.red[100],
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.grey),
                    ),
                  ),
                ),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  elevation: 2.0,
                  color: Colors.amber[50],
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
          ),
        );
      }
    );


  }

}