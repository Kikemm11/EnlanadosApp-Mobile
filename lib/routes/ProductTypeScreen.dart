import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/widgets/widgets.dart';
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

// Fetch products for initial state
  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    await context.read<ProductTypeController>().getAllProductTypes();
    setState(() {
    });
  }


  // Main widget

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400, // Increase font weight for better visibility
                        color: Colors.black,
                        fontSize: 30.0, // Increase font size
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // Space between the text and the list of cards
                  Consumer<ProductTypeController>(
                    builder: (context, value, child) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: value.productTypes.length,
                          itemBuilder: (context, index) {
                            ProductType productType = value.productTypes[index];
                            return Dismissible(
                              key: Key(productType.id.toString()),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                bool shouldDelete = await _showDeleteConfirmationDialog(productType);
                                return shouldDelete;
                              },
                              onDismissed: (direction) async {
                                String result = await context.read<ProductTypeController>().deleteProductType(productType);
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
                                margin: EdgeInsets.only(right: 70.0, top: 6.0, bottom: 6.0, left: 70.0),
                                elevation: 2.0,
                                color: Colors.yellow[50],
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
                                      _showEditProductTypeFormDialog(productType);
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

                  ProductType productType = ProductType(name: name, productId: productId , price: double.tryParse(price)!);
                  String result = await context.read<ProductTypeController>().insertProductType(productType);

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

  void _showEditProductTypeFormDialog(ProductType productType) {
    // Controllers for text fields
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

                  String result = await context.read<ProductTypeController>().updateProductType(productType);

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