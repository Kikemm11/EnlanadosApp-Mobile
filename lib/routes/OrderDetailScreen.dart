import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:enlanados_app_mobile/models/models.dart';
import 'package:enlanados_app_mobile/controllers/controllers.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();
  String? client;
  int? city;
  int? paymentMethod;
  String? estimatedDateString;
  DateTime? estimatedDate;
  double? credit;

  bool readOnlyFields = true;
  int orderId = 0;
  bool fetch = true;

  // Fetch products for initial state
  @override
  void initState() {
    super.initState();
    _fetchCities();
    _fetchPaymentMethods();
    _fetchOrderItems();
    _fetchProducts();
  }

  Future<void> _fetchCities() async {
    await context.read<CityController>().getAllCities();
    setState(() {});
  }

  Future<void> _fetchPaymentMethods() async {
    await context.read<PaymentMethodController>().getAllPaymentMethods();
    setState(() {});
  }

  Future<void> _fetchOrderItems() async {
    await context.read<ItemController>().getOrderItems(orderId);
    setState(() {});
  }

  Future<void> _fetchProducts() async {
    await context.read<ProductController>().getAllProducts();
    setState(() {});
  }

  Future<void> _fetchProductProductTypes(int productId) async {
    await context.read<ProductTypeController>().getProductProductTypes(productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Order order = args['order']!;

    if (fetch){
      setState(() {
        orderId = order.id!;
        fetch = false;
      });

      _fetchOrderItems();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.cyan[600],
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: TextEditingController(text: order.client),
                        readOnly: readOnlyFields,
                        decoration: const InputDecoration(
                          labelText: 'Cliente',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'No te olvides del nombre\ndel cliente!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            client = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Consumer<CityController>(
                          builder: (context, value, child) {
                            return DropdownButtonFormField<String>(
                              value: order.cityId.toString(),
                              decoration: InputDecoration(
                                labelText: 'Destino',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                              dropdownColor: Colors.cyan[50],
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.cyan[600],
                              ),
                              iconSize: 21.0,
                              items: value.cities
                                  .map(
                                    (city) => DropdownMenuItem(
                                  value: city.id.toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_city,
                                          color: Colors.cyan[600]),
                                      SizedBox(width: 8.0),
                                      Text(city.name),
                                    ],
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: readOnlyFields ? null :(value) {
                                setState(() {
                                  city = int.tryParse(value!);
                                });
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecciona un destino!';
                                }
                                return null;
                              },
                              menuMaxHeight: 350.0,
                            );
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.orange[600], thickness: 1.0),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Consumer<PaymentMethodController>(
                          builder: (context, value, index) {
                            return DropdownButtonFormField<String>(
                              value: order.paymentMethodId.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Método de Pago',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                              dropdownColor: Colors.cyan[50],
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.cyan[600],
                              ),
                              iconSize: 21.0,
                              items: value.paymentMethods
                                  .map((method) => DropdownMenuItem(
                                value: method.id.toString(),
                                child: Row(
                                  children: [
                                    Icon(Icons.currency_exchange,
                                        color: Colors.cyan[600]),
                                    SizedBox(width: 8.0),
                                    Text(method.name),
                                  ],
                                ),
                              ))
                                  .toList(),
                              onChanged: readOnlyFields ? null :(value) {
                                setState(() {
                                  paymentMethod = int.tryParse(value!);
                                });
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Ajá y con que te van\na pagar?!';
                                }
                                return null;
                              },
                            );
                          }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        readOnly: readOnlyFields,
                        controller: TextEditingController(text: order.credit.toString()),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Abono',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          setState(() {
                            credit = double.tryParse(value ?? '0');
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.orange[600], thickness: 1.0),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Fecha Estimada',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.cyan[600]),
                      onPressed: readOnlyFields ? null :() => _selectDate(context),
                    ),
                  ),
                  controller:
                  TextEditingController(text: estimatedDateString ?? '${order.estimatedDate.day}/${order.estimatedDate.month}/${order.estimatedDate.year}'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value == 'Seleccionar Fecha') {
                      return 'Selecciona una fecha!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.orange[600], thickness: 1.0),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Productos',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.cyan[600]),
                          onPressed: readOnlyFields ? null :() async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              _showCreateOrderItemFormDialog(orderId);

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Debes llenar la información del pedido primero\nantes de agregar productos!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Consumer<ItemController>(
                      builder: (context, value, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.items.length,
                          itemBuilder: (context, index) {
                            Item item = value.items[index];

                            return FutureBuilder<ProductType?>(
                              future: context
                                  .read<ProductTypeController>()
                                  .getOneProductType(item.productTypeId),
                              builder: (context, snapshot) {

                                if (!snapshot.hasData || snapshot.data == null) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    elevation: 1.0,
                                    color: Colors.cyan[50],
                                    child: ListTile(
                                      title: Text('Product not found'),
                                    ),
                                  );
                                }

                                ProductType productType = snapshot.data!;

                                return Dismissible(

                                  key: Key(item.id.toString()),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: readOnlyFields ? null :(direction) async {
                                    // Show confirmation dialog before dismissing
                                    bool shouldDelete = await _showDeleteConfirmationDialog();
                                    return shouldDelete; // Only dismiss the card if the user confirmed the deletion
                                  },
                                  onDismissed: readOnlyFields ? null :(direction) async {
                                    String result = await context.read<ItemController>().deleteItem(item, orderId);
                                    setState(() {
                                      _fetchOrderItems();
                                    });
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
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    elevation: 1.0,
                                    color: Colors.cyan[50],
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 0.0),
                                      title: Text(
                                        productType.name,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Text(
                                        'Total: ${(productType.price + item.addedPrice - item.discount).toString()} \$',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.grey,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          _showItemDetailDialog(context, item, productType);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );

                      }),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {



                      if (readOnlyFields) {
                        print(order.statusId);
                        if (order.statusId == 1){
                          setState(() {
                            readOnlyFields = false;
                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No puedes editar un Pedido Entregado o Cancelado!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        }
                      else {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          order.client = client!;
                          order.cityId = city == null ? order.cityId : city!;
                          order.paymentMethodId = paymentMethod == null ? order.paymentMethodId : paymentMethod!;
                          order.credit = credit!;
                          order.estimatedDate = estimatedDate == null ? order.estimatedDate : estimatedDate!;
                          String result = await OrderController().updateOrder(order);

                          if (result == 'Ok') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pedido actualizado!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al actualizar el pedido!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                      textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    child: Text(readOnlyFields ? 'Editar' : 'Actualizar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        estimatedDateString = "${picked.day}-${picked.month}-${picked.year}";
        estimatedDate = picked;
      });
    }
  }

  Future<ProductType> _getItemProductType(BuildContext context,
      ProductTypeController value, int productTypeId) async {
    await context
        .read<ProductTypeController>()
        .getOneProductType(productTypeId);
    return value.currentProductType!;
  }

  Future<Product> _getProduct(BuildContext context,
      ProductController value, int productId) async {
    await context
        .read<ProductController>()
        .getOneProduct(productId);
    return value.currentProduct!;
  }


  // Dialog create Order Item

  void _showCreateOrderItemFormDialog(int currentOrderId) {
    int orderId = currentOrderId;
    int? productTypeId;
    String description = '';
    double? addedPrice;
    double? discount;

    Product? product;
    ProductType? productType;
    bool productTypeReadOnly = true;
    TextEditingController _priceController = TextEditingController(text:'0.0');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Producto'),
          scrollable: true,
          content: Form(
            key: _itemFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<ProductController>(
                      builder: (context, values, index) {
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Producto',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                          dropdownColor: Colors.cyan[50],
                          icon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.cyan[600],
                          ),
                          iconSize: 21.0,
                          items: values.products
                              .map((product) => DropdownMenuItem(
                            value: product.id.toString(),
                            child: Row(
                              children: [
                                Icon(Icons.shopping_bag,
                                    color: Colors.cyan[600]),
                                SizedBox(width: 8.0),
                                Text(product.name),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: (value) async {

                            setState(() {
                              productTypeReadOnly = true;
                            });
                            if (value != null) {
                              int? parsedId = int.tryParse(value);

                              if (parsedId != null) {
                                // Fetch the product type asynchronously
                                Product? fetchedProduct = await _getProduct(context, values, parsedId);

                                if (fetchedProduct != null) {
                                  // Update the state after fetching the ProductType
                                  setState(() {
                                    product = fetchedProduct;
                                    productType = null;
                                    productTypeId = null;
                                    _fetchProductProductTypes(parsedId);
                                    productTypeReadOnly = false;
                                    _priceController.text = '0.0';
                                  });
                                }
                              }
                            }
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'No olvides seleccionar el producto papá, amor!';
                            }
                            return null;
                          },
                        );
                      }),
                  SizedBox(
                    height: 15.0,
                  ),
                  Consumer<ProductTypeController>(
                      builder: (context, values, index) {
                        return DropdownButtonFormField<String>(
                          value: productTypeId?.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Producto',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                          dropdownColor: Colors.cyan[50],
                          icon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.cyan[600],
                          ),
                          iconSize: 21.0,
                          items: values.productProductTypes
                              .map((product) => DropdownMenuItem(
                            value: product.id.toString(),
                            child: Row(
                              children: [
                                Icon(Icons.shopping_bag,
                                    color: Colors.cyan[600]),
                                SizedBox(width: 8.0),
                                Text(product.name),
                              ],
                            ),
                          ))
                              .toList(),
                          onChanged: productTypeReadOnly ? null : (value) async {
                            if (value != null) {
                              int? parsedId = int.tryParse(value);

                              if (parsedId != null) {
                                // Fetch the product type asynchronously
                                ProductType? fetchedProductType = await _getItemProductType(context, values, parsedId);

                                if (fetchedProductType != null) {
                                  // Update the state after fetching the ProductType
                                  setState(() {
                                    productType = fetchedProductType;
                                    productTypeId = productType?.id;
                                    _priceController.text = productType?.price.toString() ?? '0.0';
                                  });
                                }
                              }
                            }
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'No olvides seleccionar el producto, amor!';
                            }
                            return null;
                          },
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      controller: _priceController, // Use the controller
                      readOnly: true, // Since it's a read-only field
                      onSaved: (value) {
                        // You can save the value if needed
                      },
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onSaved: (value) {
                      description = value ?? '';
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Extra',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    controller: TextEditingController(text: '0.0'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      addedPrice = double.tryParse(value ?? '0');
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descuento',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    controller: TextEditingController(text: '0.0'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      discount = double.tryParse(value ?? '0');
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }

                      if (productType != null){
                        if (double.tryParse(value)! > (productType!.price)){
                          return 'Ese descuento está como raro!';
                        }
                      }

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
                if (_itemFormKey.currentState!.validate()) {
                  _itemFormKey.currentState!.save();
                  Item item = Item(orderId: orderId, productTypeId: productTypeId!, description: description, addedPrice: addedPrice!, discount: discount!);
                  String result = await context
                      .read<ItemController>()
                      .insertItem(item);

                  if (result != 'Ok') {
                    String message =
                        'Ups, ha ocurrido un error agregando el producto!';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto agregado!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  setState(() {
                    _fetchOrderItems();
                  });
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


  // Dialog confirm delete Item

  Future<bool> _showDeleteConfirmationDialog() async {
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar el producto del pedido?'),
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

  // Dialog to show item details

  void _showItemDetailDialog(BuildContext context, Item item, ProductType productType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            productType.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Descripción:\n\n${item.description}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Precio: ${productType.price} \$',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Extra: ${item.addedPrice} \$',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Adds space between rows
              Center(
                child: Text(
                  'Descuento: ${item.discount} \$',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cerrar',
              ),
            ),
          ],
        );
      },
    );
  }


}
