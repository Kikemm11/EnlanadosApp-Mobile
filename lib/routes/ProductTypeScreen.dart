/*
This file contains the definition and functionalities of ProductType Screen

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/models/ProductType.dart';
import 'package:enlanados_app_mobile/controllers/ProductTypeController.dart';


class ProductTypeScreen extends StatefulWidget {
  const ProductTypeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ProductTypeScreenState createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // Main Screen
  @override
  Widget build(BuildContext context) {
    // Recieve prev Screen parameters
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final productId = args['productId']!;
    final productName = args['productName']!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
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
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Parent product name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400, 
                        color: Colors.black,
                        fontSize: 30.0, 
                      ),
                    ),
                  ),
                  SizedBox(height: 30), 
                  Consumer<ProductTypeController>(
                    builder: (context, value, child) {
                      return Expanded(
                        // Product types list
                        child: ListView.builder(
                          itemCount: value.productProductTypes.length,
                          itemBuilder: (context, index) {
                            ProductType productType = value.productProductTypes[index];
                            return Dismissible(
                              key: Key(productType.id.toString()),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                // Show confirmation dialog before dismissing
                                bool shouldDelete = await _showDeleteConfirmationDialog(productType);
                                return shouldDelete;  // Only dismiss the card if the user confirmed the deletion
                              },
                              onDismissed: (direction) async {
                                String result = await context.read<ProductTypeController>().deleteProductType(productType, productId);
                                if (result == 'Ok') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Tipo de Producto eliminado!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error al eliminar el Tipo de Producto'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  Navigator.pop(context);
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

                              // Product type card info
                              child: Card(
                                margin: EdgeInsets.only(right: 70.0, top: 6.0, bottom: 6.0, left: 70.0),
                                elevation: 8.0,
                                color: Colors.green[50],
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  leading: Icon(Icons.shopping_bag, color: Colors.green[200]),
                                  title: Text(
                                    productType.name,
                                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                  ),
                                  subtitle: Text(
                                    '${productType.price.toString()}\$',
                                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.orange[600],
                                    ),
                                    onPressed: () {
                                      _showEditProductTypeFormDialog(productType, productId);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        // Creates new product type
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _showCreateProductTypeFormDialog(productId);
            },
          backgroundColor: Colors.orange[100],
          child: const Icon(Icons.add),
        ),
      ),
    );
  }


  // Screen methods

  // Dialog create ProductType
  void _showCreateProductTypeFormDialog(int productId) {

    String name = '';
    String price = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nuevo Tipo de Producto'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) {
                      name = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un nombre, amorcito!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      price = value ?? '0';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un precio, amorcito!';
                      }
                      if (double.tryParse(value)! < 0.0) {
                        return 'El precio no puede ser negativo, cielo!';
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

                  ProductType productType = ProductType(name: name, productId: productId , price: double.tryParse(price)!);
                  String result = await context.read<ProductTypeController>().insertProductType(productType, productId);

                  if (result != 'Ok'){

                    String message = 'Ups, ha ocurrido un error creando el producto!';

                    if (result == 'UNIQUE'){ message = 'Ese tipo de producto ya existe, tontita!'; }

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
                        content: Text('Tipo de producto creado!'),
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


  // Dialog edit Product Type
  void _showEditProductTypeFormDialog(ProductType productType, int productId) {
    TextEditingController nameController = TextEditingController(text: productType.name);
    TextEditingController priceController = TextEditingController(text: productType.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tipo de Producto'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) {
                      productType.name = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un nombre, amorcito!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      productType.price = double.tryParse(value!) ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un precio, amorcito!';
                      }
                      if (double.tryParse(value)! < 0.0) {
                        return 'El precio no puede ser negativo!';
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

                  String result = await context.read<ProductTypeController>().updateProductType(productType, productId);

                  if (result != 'Ok') {
                    String message = 'Ups, ha ocurrido un error actualizando el producto!';
                    if (result == 'UNIQUE') {
                      message = 'Ese producto ya existe, tontita!';
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
                        content: Text('Producto actualizado!'),
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


  // Dialog confirm delete Product Type
  Future<bool> _showDeleteConfirmationDialog(ProductType productType) async {
    String productTypeName = productType.name;
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar el producto "$productTypeName"?'),
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