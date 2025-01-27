/*
This file contains all the Database logic, conection and querys

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import 'package:enlanados_app_mobile/models/models.dart';

// Class definition
class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  // Singleton Database instance
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  // Enable SQLITE foreign keys
  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  // Insert initial data

  _insertInitialData(Database db) async {
    String createdAt = DateTime.now().toIso8601String();

    // Insert Venezuela's cities
    await db.insert('city', {"name": "Mérida", "created_at": createdAt});
    await db.insert('city', {"name": "Caracas", "created_at": createdAt});
    await db.insert('city', {"name": "Aragua", "created_at": createdAt});
    await db.insert('city', {"name": "Trujillo", "created_at": createdAt});
    await db.insert('city', {"name": "Zulia", "created_at": createdAt});
    await db.insert('city', {"name": "Táchira", "created_at": createdAt});
    await db.insert('city', {"name": "Falcón", "created_at": createdAt});
    await db.insert('city', {"name": "Lara", "created_at": createdAt});
    await db.insert('city', {"name": "Portuguesa", "created_at": createdAt});
    await db.insert('city', {"name": "Barinas", "created_at": createdAt});
    await db.insert('city', {"name": "Apure", "created_at": createdAt});
    await db.insert('city', {"name": "Vargas", "created_at": createdAt});
    await db.insert('city', {"name": "Cojedes", "created_at": createdAt});
    await db.insert('city', {"name": "Sucre", "created_at": createdAt});
    await db.insert('city', {"name": "Nueva Esparta", "created_at": createdAt});
    await db.insert('city', {"name": "Anzoátegui", "created_at": createdAt});
    await db.insert('city', {"name": "Monagas", "created_at": createdAt});
    await db.insert('city', {"name": "Bolívar", "created_at": createdAt});
    await db.insert('city', {"name": "Amazonas", "created_at": createdAt});
    await db.insert('city', {"name": "Delta Amacuro", "created_at": createdAt});
    await db.insert('city', {"name": "Carabobo", "created_at": createdAt});
    await db.insert('city', {"name": "Guárico", "created_at": createdAt});
    await db.insert('city', {"name": "Miranda", "created_at": createdAt});
    await db.insert('city', {"name": "Yaracuy", "created_at": createdAt});

    // Insert Payment Methods
    await db.insert('payment_method', {"name": "Efectivo \$", "created_at": createdAt});
    await db.insert('payment_method', {"name": "Pago Móvil Bs", "created_at": createdAt});

    // Insert Statuses
    await db.insert('status', {"id": 1, "name": "Pendiente", "created_at": createdAt});
    await db.insert('status', {"id": 2, "name": "Entregado", "created_at": createdAt});
    await db.insert('status', {"id": 3, "name": "Cancelado", "created_at": createdAt});

}

  // DB initializer
  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'enlanados_app_mobile.db'), onConfigure: _onConfigure,
        onCreate: (db, version) async {

          await db.execute('''
          CREATE TABLE product (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          created_at TEXT 
          );
          ''');

          await db.execute('''
          CREATE TABLE product_type (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          product_id INTEGER NOT NULL,
          price REAL NOT NULL CHECK(price > 0),
          created_at TEXT,
          FOREIGN KEY (product_id) REFERENCES product(id)
        );
        ''');

          await db.execute('''
          CREATE TABLE city (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          created_at TEXT 
          );
          ''');

          await db.execute('''
          CREATE TABLE payment_method (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          created_at TEXT 
          );
          ''');

          await db.execute('''
          CREATE TABLE status (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          created_at TEXT 
          );
          ''');

          await db.execute('''
          CREATE TABLE wool_stock (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          color TEXT UNIQUE NOT NULL,
          quantity INTEGER NOT NULL CHECK(quantity >= 0),
          last_updated TEXT NOT NULL,
          created_at TEXT 
          );
          ''');

          await db.execute('''
          CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          client TEXT NOT NULL,
          city_id INTEGER NOT NULL,
          credit REAL CHECK(credit >= 0.0),
          payment_method_id INTEGER NOT NULL,
          estimated_date TEXT NOT NULL,
          status_id INTEGER NOT NULL,
          created_at TEXT,
          FOREIGN KEY (city_id) REFERENCES city(id),
          FOREIGN KEY (payment_method_id) REFERENCES payment_method(id),
          FOREIGN KEY (status_id) REFERENCES status(id)
          );
          ''');

          await db.execute('''
          CREATE TABLE item (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          order_id INTEGER NOT NULL,
          product_type_id INTEGER NOT NULL,
          description TEXT,
          added_price REAL CHECK(added_price >= 0.0),
          discount REAL CHECK(discount >= 0.0),
          created_at TEXT,
          FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
          FOREIGN KEY (product_type_id) REFERENCES product_type(id)
          );
          ''');

          await _insertInitialData(db);

        },
        version: 2
    );
  }


  // City querys

  // Read methods

  Future<List<City>> readAllCities() async {
    final db = await database;
    final result = await db!.query(
      'city',
      orderBy: 'name ASC',
    );
    return result.map((e)=> City.fromJson(e)).toList();
  }

  Future<City> readOneCity(int cityId) async {
    final db = await database;
    final maps = await db!.query(
      'city',
      columns: ['id', 'name', 'created_at'],
      where: 'id = ?',
      whereArgs: [cityId],
    );

    if (maps.isNotEmpty) {
      return City.fromJson(maps.first);
    }
    else {
      throw Exception('City not found');
    }
  }


  // Status querys

  // Read methods

  Future<List<Status>> readAllStatuses() async {
    final db = await database;
    final result = await db!.query(
      'status',
      orderBy: 'id ASC',
    );
    return result.map((e)=> Status.fromJson(e)).toList();
  }

  Future<Status> readOneStatus(int statusId) async {
    final db = await database;
    final maps = await db!.query(
      'status',
      columns: ['id', 'name', 'created_at'],
      where: 'id = ?',
      whereArgs: [statusId],
    );

    if (maps.isNotEmpty) {
      return Status.fromJson(maps.first);
    }
    else {
      throw Exception('Status not found');
    }
  }


  // PaymentMethod querys

  // Read methods

  Future<List<PaymentMethod>> readAllPaymentMethods() async {
    final db = await database;
    final result = await db!.query(
      'payment_method',
      orderBy: 'id ASC',
    );
    return result.map((e)=> PaymentMethod.fromJson(e)).toList();
  }

  Future<PaymentMethod> readOnePaymentMethod(int paymentMethodId) async {
    final db = await database;
    final maps = await db!.query(
      'payment_method',
      columns: ['id', 'name', 'created_at'],
      where: 'id = ?',
      whereArgs: [paymentMethodId],
    );

    if (maps.isNotEmpty) {
      return PaymentMethod.fromJson(maps.first);
    }
    else {
      throw Exception('Payment Method not found');
    }
  }


  // Product querys

  // Read methods

  Future<List<Product>> readAllProducts() async {
    final db = await database;
    final result = await db!.query(
      'product',
      orderBy: 'id ASC',
    );
    return result.map((e)=> Product.fromJson(e)).toList();
  }

  Future<Product> readOneProduct(int productId) async {
    final db = await database;
    final maps = await db!.query(
      'product',
      columns: ['id', 'name', 'created_at'],
      where: 'id = ?',
      whereArgs: [productId],
    );

    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    }
    else {
      throw Exception('Product not found');
    }
  }

  // Insert Method

  Future<Product> insertProduct(Product product) async {
    final db =  await database;
    int id = await db!.insert('product', product.toJson());
    product.id = id;
    return product;
  }

  // Update Method

  Future<Product> updateProduct(Product product) async {
    final db =  await database;
    await db!.update(
        'product',
        product.toJson(),
        where: 'id = ?',
        whereArgs: [product.id]
    );
    return product;
  }

  // Delete method

  Future<int> deleteProduct(Product product) async {
    final db = await database;
    return db!.delete(
        'product',
        where: 'id = ?',
        whereArgs: [product.id]
    );
  }


  // ProductType querys

  // Read methods

  Future<List<ProductType>> readAllProductTypes() async {
    final db = await database;
    final result = await db!.query(
      'product_type',
      orderBy: 'id ASC',
    );
    return result.map((e)=> ProductType.fromJson(e)).toList();
  }

  Future<List<ProductType>> readProductProductTypes(int productId) async {
    final db = await database;
    final result = await db!.query(
      'product_type',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'id ASC',
    );
    return result.map((e)=> ProductType.fromJson(e)).toList();
  }

  Future<ProductType> readOneProductType(int productTypeId) async {
    final db = await database;
    final maps = await db!.query(
      'product_type',
      columns: ['id', 'name', 'product_id', 'price', 'created_at'],
      where: 'id = ?',
      whereArgs: [productTypeId],
    );

    if (maps.isNotEmpty) {
      return ProductType.fromJson(maps.first);
    }
    else {
      throw Exception('ProductType not found');
    }
  }

  // Insert Method

  Future<ProductType> insertProductType(ProductType productType) async {
    final db =  await database;
    int id = await db!.insert('product_type', productType.toJson());
    productType.id = id;
    return productType;
  }

  // Update Method

  Future<ProductType> updateProductType(ProductType productType) async {
    final db =  await database;
    await db!.update(
        'product_type',
        productType.toJson(),
        where: 'id = ?',
        whereArgs: [productType.id]
    );
    return productType;
  }

  // Delete method

  Future<int> deleteProductType(ProductType productType) async {
    final db = await database;
    return db!.delete(
        'product_type',
        where: 'id = ?',
        whereArgs: [productType.id]
    );
  }


  // WoolStock querys

  // Read methods

  Future<List<WoolStock>> readAllWoolStock() async {
    final db = await database;
    final result = await db!.query(
      'wool_stock',
      orderBy: 'id ASC',
    );
    return result.map((e)=> WoolStock.fromJson(e)).toList();
  }

  Future<WoolStock> readOneWoolStock(WoolStock woolStock) async {
    final db = await database;
    final maps = await db!.query(
      'wool_stock',
      columns: ['id', 'color', 'quantity', 'last_updated', 'created_at'],
      where: 'id = ?',
      whereArgs: [woolStock.id],
    );

    if (maps.isNotEmpty) {
      return WoolStock.fromJson(maps.first);
    }
    else {
      throw Exception('WoolStock not found');
    }
  }

  // Insert Method

  Future<WoolStock> insertWoolStock(WoolStock woolStock) async {
    final db =  await database;
    int id = await db!.insert('wool_stock', woolStock.toJson());
    woolStock.id = id;
    return woolStock;
  }

  // Update Method

  Future<WoolStock> updateWoolStock(WoolStock woolStock) async {
    final db =  await database;
    woolStock.lastUpdated = DateTime.now();
    await db!.update(
        'wool_stock',
        woolStock.toJson(),
        where: 'id = ?',
        whereArgs: [woolStock.id]
    );
    return woolStock;
  }

  // Delete method

  Future<int> deleteWoolStock(WoolStock woolStock) async {
    final db = await database;
    return db!.delete(
        'wool_stock',
        where: 'id = ?',
        whereArgs: [woolStock.id]
    );
  }


  // Order querys

  // Read methods

  Future<List<Order>> readCurrentMonthWhitStatusOrders() async {
    final db = await database;
    DateTime now = DateTime.now();
    String currentYear = now.year.toString();
    String currentMonth = now.month.toString().padLeft(2, '0');

    final result = await db!.query(
      'orders',
      where: "strftime('%Y', created_at) = ? AND strftime('%m', created_at) = ? AND status_id = 1",
      whereArgs: [currentYear, currentMonth],
      orderBy: 'id ASC',
    );

    return result.map((e) => Order.fromJson(e)).toList();
  }

  Future<List<Order>> readCurrentMonthOrders() async {
    final db = await database;
    DateTime now = DateTime.now();
    String currentYear = now.year.toString();
    String currentMonth = now.month.toString().padLeft(2, '0'); // Ensure month is two digits

    final result = await db!.query(
      'orders',
      where: "strftime('%Y', created_at) = ? AND strftime('%m', created_at) = ?",
      whereArgs: [currentYear, currentMonth],
      orderBy: 'id ASC',
    );

    return result.map((e) => Order.fromJson(e)).toList();
  }

  Future<List<Order>> readFilteredOrders(Map<String, dynamic> filterData) async {
    final db = await database;

    // Base query
    String query = 'SELECT * FROM orders';
    List<String> conditions = [];
    List<dynamic> arguments = [];

    // Check each filter and add to the conditions and arguments if not null
    if (filterData['client'] != null) {
      conditions.add('LOWER(client) LIKE LOWER(?)');
      arguments.add(filterData['client']);
    }
    if (filterData['city'] != null) {
      conditions.add('city_id = ?');
      arguments.add(filterData['city']);
    }
    if (filterData['paymentMethod'] != null) {
      conditions.add('payment_method_id = ?');
      arguments.add(filterData['paymentMethod']);
    }
    if (filterData['status'] != null) {
      conditions.add('status_id = ?');
      arguments.add(filterData['status']);
    }

    // Handle date filtering
    if (filterData['fromDate'] != null && filterData['toDate'] != null) {
      conditions.add('created_at BETWEEN ? AND ?');
      arguments.add(filterData['fromDate'].toIso8601String());
      arguments.add(filterData['toDate'].toIso8601String());
    }

    // Append conditions to the query if any exist
    if (conditions.isNotEmpty) {
      query += ' WHERE ${conditions.join(' AND ')}';
    }

    query += ' ORDER BY id ASC';

    final result = await db!.rawQuery(query, arguments);

    return result.map((e) => Order.fromJson(e)).toList();
  }

  Future<List<Order>> readStatisticsOrders(Map<String, dynamic> dateData) async {
    final db = await database;

    // Base query
    String query = 'SELECT * FROM orders';
    List<String> conditions = [];
    List<dynamic> arguments = [];

    conditions.add('created_at BETWEEN ? AND ?');
    arguments.add(dateData['fromDate']!.toIso8601String());
    arguments.add(dateData['toDate']!.toIso8601String());

    query += ' WHERE ${conditions.join(' AND ')}';
    query += 'AND status_id = 2 ORDER BY id ASC';

    final result = await db!.rawQuery(query, arguments);

    return result.map((e) => Order.fromJson(e)).toList();

  }


  Future<Order> readOneOrder(Order order) async {
    final db = await database;
    final maps = await db!.query(
      'orders',
      columns: ['id', 'client', 'city_id', 'credit', 'payment_method_id', 'estimated_date',
        'status_id', 'created_at'],
      where: 'id = ?',
      whereArgs: [order.id],
    );

    if (maps.isNotEmpty) {
      return Order.fromJson(maps.first);
    }
    else {
      throw Exception('Order not found');
    }
  }

  // Insert Method

  Future<Order> insertOrder(Order order) async {
    final db =  await database;
    int id = await db!.insert('orders', order.toJson());
    order.id = id;
    return order;
  }

  // Update Methods

  Future<Order> updateOrder(Order order) async {
    final db =  await database;
    await db!.update(
        'orders',
        order.toJson(),
        where: 'id = ?',
        whereArgs: [order.id]
    );
    return order;
  }

  Future<Order> deliverOrder(Order order) async {
    final db =  await database;
    order.statusId = 2;
    await db!.update(
        'orders',
        order.toJson(),
        where: 'id = ?',
        whereArgs: [order.id]
    );
    return order;
  }

  Future<Order> cancelOrder(Order order) async {
    final db =  await database;
    order.statusId = 3;
    await db!.update(
        'orders',
        order.toJson(),
        where: 'id = ?',
        whereArgs: [order.id]
    );
    return order;
  }


  // Delete method

  Future<int> deleteOrder(int orderId) async {
    final db = await database;
    return db!.delete(
        'orders',
        where: 'id = ?',
        whereArgs: [orderId]
    );
  }

  // Item querys

  // Read methods

  Future<List<Item>> readOrderItems(int orderId) async {
    final db = await database;
    final result = await db!.query(
      'item',
      where: 'order_id = ?',
      whereArgs: [orderId],
      orderBy: 'id ASC',
    );
    return result.map((e)=> Item.fromJson(e)).toList();
  }

  Future<Item> readOneItem(Item item) async {
    final db = await database;
    final maps = await db!.query(
      'item',
      columns: ['id', 'order_id', 'product_type_id', 'description', 'added_price', 'discount', 'created_at'],
      where: 'id = ?',
      whereArgs: [item.id],
    );

    if (maps.isNotEmpty) {
      return Item.fromJson(maps.first);
    }
    else {
      throw Exception('Item not found');
    }
  }

  // Insert Method

  Future<Item> insertItem(Item item) async {
    final db =  await database;
    int id = await db!.insert('item', item.toJson());
    item.id = id;
    return item;
  }

  // Update Methods

  Future<Item> updateItem(Item item) async {
    final db =  await database;
    await db!.update(
        'item',
        item.toJson(),
        where: 'id = ?',
        whereArgs: [item.id]
    );
    return item;
  }



  // Delete method

  Future<int> deleteItem(Item item) async {
    final db = await database;
    return db!.delete(
        'item',
        where: 'id = ?',
        whereArgs: [item.id]
    );
  }

}