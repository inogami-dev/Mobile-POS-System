import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern to ensure only one database instance exists
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_offline_mposs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  /// To initialize some needed database configurations
  Future<void> _onConfigure(Database db) async {
    // SQLite disables foreign keys by default. This is to turn them on!
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // await db.execute('''
    //   CREATE TABLE offline_tasks (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     task_name TEXT NOT NULL,
    //     is_synced INTEGER DEFAULT 0
    //   )
    // ''');
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        particulars TEXT NOT NULL, 
        totalAmount INTEGER NOT NULL,
        payment INTEGER NOT NULL,
        change INTEGER NOT NULL,
        dateTime DATE NOT NULL,
        cashierId TEXT NOT NULL
      )
    ''');
  }

  // // --------------------
  // Future<Map> getSales() async {
  //   return {};
  // }

  // Future<int> addSales() async {
  //   final db = await DatabaseHelper._database;

  //   return 1;
  // }
}
