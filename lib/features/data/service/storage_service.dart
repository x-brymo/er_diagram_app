// storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StorageService {
  late Database _database;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  Future<void> initialize() async {
    // Initialize SQLite database
    _database = await openDatabase(
      join(await getDatabasesPath(), 'er_diagram_database.db'),
      onCreate: (db, version) async {
        // Create tables
        await db.execute(
          'CREATE TABLE diagrams(id TEXT PRIMARY KEY, name TEXT, data TEXT, created_at INTEGER, updated_at INTEGER)',
        );
      },
      version: 1,
    );
  }
  
  // Secure storage methods
  Future<void> saveSecurely(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
  
  Future<String?> getSecureValue(String key) async {
    return await _secureStorage.read(key: key);
  }
  
  // SQLite methods
  Future<void> saveDiagram(String id, String name, String data) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    await _database.insert(
      'diagrams',
      {
        'id': id,
        'name': name,
        'data': data,
        'created_at': timestamp,
        'updated_at': timestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<List<Map<String, dynamic>>> getAllDiagrams() async {
    return await _database.query('diagrams', orderBy: 'updated_at DESC');
  }
  
  Future<Map<String, dynamic>?> getDiagram(String id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'diagrams',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
  
  Future<void> deleteDiagram(String id) async {
    await _database.delete(
      'diagrams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}