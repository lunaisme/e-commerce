import 'dart:async';
import 'dart:convert';
import 'package:ecommerce_app_with_flutter/src/data/model/cart/cart_model.dart';
import 'package:ecommerce_app_with_flutter/src/data/model/users/users_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ecommerce.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Tabel users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        image TEXT
      )
    ''');

    // Tabel cart
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId VARCHAR UNIQUE,
        productName TEXT,
        initialPrice REAL,
        productPrice REAL,
        quantity INTEGER,
        img TEXT
      )
    ''');
  }

  // ========================== USER METHODS ==========================
  String encryptPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> registerUser(User user) async {
    final db = await instance.database;
    final encryptedPassword = encryptPassword(user.password);
    final userData = user.toMap()..['password'] = encryptedPassword;
    return await db.insert('users', userData);
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await database;

    try {
      // Tambahkan print untuk debugging
      print('Attempting login with email: $email');

      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        final user = User.fromMap(result.first);

        // Verifikasi password
        if (PasswordHash.verifyPassword(password, user.password)) {
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Error in loginUser: $e');
      return null;
    }
  }

  // Method untuk mengecek apakah email sudah terdaftar
  Future<bool> isEmailRegistered(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Method untuk melihat semua user (untuk debugging)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateProfile(User user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<Map<String, dynamic>?> getUser(int userId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // ========================== CART METHODS ==========================
  Future<Cart> insertToCart(Cart cart) async {
    final db = await instance.database;
    await db.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    final db = await instance.database;
    final List<Map<String, Object?>> queryResult = await db.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> updateCartQuantity(Cart cart) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      cart.quantityToMap(),
      where: 'productId = ?',
      whereArgs: [cart.productId],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }
}

class PasswordHash {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(String password, String hashedPassword) {
    final hash = hashPassword(password);
    return hash == hashedPassword;
  }
}
