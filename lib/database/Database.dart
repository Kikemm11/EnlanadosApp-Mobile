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
          product_type_id INTEGER NOT NULL,
          description TEXT,
          added_price REAL CHECK(added_price >= 0.0),
          credit REAL CHECK(credit >= 0.0),
          payment_method_id INTEGER NOT NULL,
          estimated_date TEXT NOT NULL,
          status_id INTEGER NOT NULL,
          created_at TEXT,
          FOREIGN KEY (city_id) REFERENCES city(id),
          FOREIGN KEY (product_type_id) REFERENCES product_type(id),
          FOREIGN KEY (payment_method_id) REFERENCES payment_method(id),
          FOREIGN KEY (status_id) REFERENCES status(id)
          );
          ''');

        },
        version: 1
    );
  }
}