import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetable_app/providers/setting_provider.dart';

class DatabaseHelper {
  static const _databaseName = "timeTable_database.db";
  static const _databaseVersion = 1;

  static const table = 'settings';

  static const columnId = 'id';
  static const columnIsDarkMode = 'isDarkMode';
  static const columnIsNotificationsEnabled = 'isNotificationsEnabled';
  static const columnLanguage = 'language';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database!;

    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnIsDarkMode INTEGER,
            $columnIsNotificationsEnabled INTEGER,
            $columnLanguage TEXT
          )
          ''');
  }

  void query() async {
    Database? db = await instance.database;
    List<Map> result = await db!.query(table);
    for (var row in result) {
      print(row);
    }
  }

  // Helper methods for settings,
  // the id is always 1, because there is only one row in the table
  Future<int> updateSetting(AppSettings settings) async {
    Database? db = await instance.database;
    int id = 1;
    return await db!.update(table, settings.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<AppSettings> getSettings() async {
    Database? db = await instance.database;
    int id = 1;
    List<Map> maps = await db!.query(table,
        columns: [
          columnId,
          columnIsDarkMode,
          columnIsNotificationsEnabled,
          columnLanguage
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      print(maps.first);
      return fromMap(maps.first);
    }
    return AppSettings(
      isDarkMode: false,
      isNotificationsEnabled: false,
      language: Language.english,
    );
  }
}
