import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  Future<Database> openDataBase() async {
    final databasepath = await getDatabasesPath();
    final path = join(databasepath, 'cine_scope.db');

    return openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        director TEXT,
        year INTEGER,
        image TEXT
      )
      ''');
    }, version: 1);
  }

  Future<void> insertMovie(Map<String, dynamic> data) async {
    final db = await openDataBase();
    await db.insert('movies', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('Movie inserted successfully');
    await db.close();
  }

  Future<List<Map<String, dynamic>>> getMovies() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), 'cine_scope.db'));
    final movies = await db.query('movies');
    await db.close();
    return movies;
  }
}
