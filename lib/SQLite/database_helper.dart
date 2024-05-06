import 'package:assignment2/JSON/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/store.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'my_store_database.db';

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  // Initialize the database
  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, dbName);
    final db = await openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) async {
        // Create 'users' table
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            userName TEXT,
            userEmail TEXT UNIQUE,
            password TEXT,
            phoneNumber TEXT
          )
        ''');

        // Create 'stores' table
        await db.execute('''
          CREATE TABLE stores(
            id INTEGER PRIMARY KEY,
            name TEXT,
            longitude REAL,
            latitude REAL,
            distance REAL
          )
        ''');

        // Create 'favorite_stores' table
        await db.execute('''
          CREATE TABLE favorite_stores(
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            store_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (store_id) REFERENCES stores(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migration logic if needed
        }
      },
    );
    return db;
  }

  // CRUD operations for stores
  Future<int> insertStore(Store store) async {
    final db = await getDatabase();
    return await db.insert(
      'stores', 
      store.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> deleteStore(int id) async {
    final db = await getDatabase();
    await db.delete(
      'stores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Store>> getAllStores() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('stores');
    return List.generate(maps.length, (i) {
      return Store(
        id: maps[i]['id'],
        name: maps[i]['name'],
        longitude: maps[i]['longitude'],
        latitude: maps[i]['latitude'],
        distance: maps[i]['distance'],
      );
    });
  }

  Future<Store?> getStoreById(int storeId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'stores',
      where: 'id = ?',
      whereArgs: [storeId],
    );
    return maps.isNotEmpty ? Store.fromMap(maps.first) : null;
  }

  // Authentication methods
  Future<bool> authenticate(User usr) async {
    final Database db = await getDatabase();
    var result = await db.rawQuery(
      "SELECT * FROM users WHERE userEmail = ? AND password = ?",
      [usr.userEmail, usr.password],
    );
    return result.isNotEmpty;
  }

  Future<int> createUser(User usr) async {
    final Database db = await getDatabase();

    // Check if the email already exists in the database
    var existingUser = await db.query(
      'users',
      where: 'userEmail = ?',
      whereArgs: [usr.userEmail],
    );

    if (existingUser.isNotEmpty) {
      return -1; // User with the same email already exists
    }

    // Insert the user record if the email is unique
    return await db.insert("users", usr.toMap());
  }

  // Store favorite stores for a user based on email
  Future<void> storeFavoriteStores(
      String userEmail, List<Store> favoriteStores) async {
    final db = await getDatabase();

    // Get user data based on email
    var user = await db.query(
      'users',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );

    if (user.isNotEmpty) {
      var userId = user.first['id'];

      // Insert new favorite stores for the user
      for (var store in favoriteStores) {
        await db.insert(
          'favorite_stores', 
          {
            'user_id': userId,
            'store_id': store.id,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore, // To avoid duplicates
        );
      }
    } else {
      print('User with email $userEmail not found.');
    }
  }

  Future<List<Store>> getFavoriteStores(int userId) async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT stores.id, stores.name, stores.longitude, stores.latitude, stores.distance
    FROM stores
    INNER JOIN favorite_stores ON stores.id = favorite_stores.store_id
    WHERE favorite_stores.user_id = ?
  ''', [userId]);

    if (maps.isEmpty) {
      return []; // No favorite stores found
    }

    return List.generate(maps.length, (i) {
      return Store(
        id: maps[i]['id'],
        name: maps[i]['name'],
        longitude: maps[i]['longitude'],
        latitude: maps[i]['latitude'],
        distance: maps[i]['distance'],
      );
    });
  }

  // Additional user-related methods
  Future<String?> getUserNameByEmail(String email) async {
    final Database db = await getDatabase();
    var res = await db.query(
      "users",
      columns: ["userName"],
      where: "userEmail = ?",
      whereArgs: [email],
    );
    return res.isNotEmpty ? res.first["userName"] as String? : null;
  }
}
