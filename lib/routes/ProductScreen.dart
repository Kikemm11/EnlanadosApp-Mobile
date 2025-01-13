import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/widgets/widgets.dart';
import 'package:enlanados_app_mobile/models/Product.dart';
import 'package:enlanados_app_mobile/controllers/ProductController.dart';



class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _selectedIndex = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Fetch products for initial state
  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    await context.read<ProductController>().getAllProducts();
    setState(() {
    });
  }


  // Main widget

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
              child: Consumer<ProductController>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: value.products.length,
                      itemBuilder: (context, index) {
                        Product product = value.products[index];
                        return Dismissible(
                          key: Key(product.id.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            // Show confirmation dialog before dismissing
                            bool shouldDelete = await _showDeleteConfirmationDialog(product);

                            return shouldDelete; // Only dismiss the card if the user confirmed the deletion
                          },
                          onDismissed: (direction) async {
                            String result = await context.read<ProductController>().deleteProduct(product);

                            if (result == 'Ok') {
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
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              leading: Icon(Icons.shopping_bag, color: Colors.green[200]),
                              title: Text(
                                product.name,
                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.orange[600],
                                    ),
                                    onPressed: () {
                                      _showEditProductFormDialog(product);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                      icon: Icon(
                                          Icons.list_sharp,
                                          color: Colors.orange[600],
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/product-types',
                                          arguments: {'productId': product.id, 'productName': product.name},
                                        );
                                      },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
              ),
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCreateProductFormDialog,
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


  // Manage the bottom navbar navigation

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

  // Dialog create product

  void _showCreateProductFormDialog() {

    String name = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nuevo Producto'),
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

                   Product product = Product(name: name);
                   String result = await context.read<ProductController>().insertProduct(product);

                  if (result != 'Ok'){

                    String message = 'Ups, ha ocurrido un error creando el producto!';

                    if (result == 'UNIQUE'){ message = 'Ese producto ya existe, tontita!'; }

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
                        content: Text('Producto creado!'),
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


  // Dialog edit Product

  void _showEditProductFormDialog(Product product) {
    // Controllers for text fields
    TextEditingController nameController = TextEditingController(text: product.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
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
                      product.name = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un nombre, amorcito!';
                      }
                      return null;
                    },
                  ),
                  // You can add more fields for editing other product attributes
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

                  String result = await context.read<ProductController>().updateProduct(product);

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

  // Dialog confirm delete Product

  Future<bool> _showDeleteConfirmationDialog(Product product) async {
    String productName = product.name;
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar el producto "$productName"?'),
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