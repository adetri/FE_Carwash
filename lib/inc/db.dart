import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../env.dart';

class DatabaseHelper {
  static Database? _database;
  final String tableName = 'con';
  final String host = APIHOST;

  Future<Database> get database async {
    if (_database != null) {
      print("init exec2");
      return _database!;
    }

    _database = await initializeDatabase();
    print("init exec");

    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'carwashDB.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, jwt TEXT, host TEXT)',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final Database db = await database;
    return db.query(tableName);
  }

  // SELECT with WHERE clause
  Future<List<Map<String, dynamic>>> getTasksById(int id) async {
    final Database db = await database;
    return db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final Database db = await database;
    return db.insert(tableName, task);
  }

  Future<List<String>> getDatabaseNames() async {
    final path = await getDatabasesPath();
    final db = await openDatabase(join(path, 'carwashDB.db'));

    List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';",
    );

    await db.close();

    List<String> databaseNames =
        tables.map((table) => table['name'] as String).toList();
    return databaseNames;
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    final Database db = await database;
    return db.update(
      tableName,
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  // DELETE operation - Delete a task
  Future<int> deleteTask(int id) async {
    final Database db = await database;
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTaskOther() async {
    final Database db = await database;
    return db.delete(
      tableName,
      where: 'id != 1',
    );
  }

  Future<int> updateHost() async {
    final Database db = await database;
    print("sadasdnasjndjsads ");
    return db.update(
      tableName,
      {'host': host},
      where: 'id = 1',
    );
  }

  // Future<String> getHost() async {
  //   final Database db = await database;
  //   return db.update(
  //     tableName,
  //     {'host': host},
  //     where: 'id = 1',
  //   );
  // }

  Future<int> updateJWT(String jwt) async {
    final Database db = await database;
    return db.update(
      tableName,
      {'jwt': jwt},
      where: 'id = 1',
    );
  }

  Future<String?> getHost() async {
    final Database db = await database;

    List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: ['host'],
      where: 'id = 1',
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> task = result.first;
      String hostName = task['host'];

      return hostName;
    } else {
      print('No host found!');
      return null; // Return null or any default value to handle the case where no host is found
    }
  }

  Future<String?> getJWT() async {
    final Database db = await database;

    List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: ['jwt'],
      where: 'id = 1',
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> task = result.first;
      String jwt = task['jwt'];

      return jwt;
    } else {
      print('No jwt found!');
      return null; // Return null or any default value to handle the case where no host is found
    }
  }

  Future<Map> getJwtHost() async {
    final Database db = await database;

    List<Map<String, dynamic>> result = await db.query(
      tableName,
      columns: ['jwt', 'host'],
      where: 'id = 1',
    );
    Map data = {'host': "", 'jwt': ""};
    if (result.isNotEmpty) {
      Map<String, dynamic> task = result.first;
      data['jwt'] = task['jwt'];
      data['host'] = task['host'];

      return data;
    } else {
      print('No jwt found!');
      return data; // Return null or any default value to handle the case where no host is found
    }
  }

  // Other CRUD operations (update, delete, etc.) can be added similarly.
}
