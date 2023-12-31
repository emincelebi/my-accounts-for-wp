import 'package:example_1/view/user_list/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  final String _userDBPath = "users";
  Database? con;
  final int _version = 1;

  Future<Database> get _database async {
    if (con != null) return con!;
    con = await connect();
    return con!;
  }

  _createDb(Database db, int newVersion) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $_userDBPath(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      age TEXT,
      team TEXT
    )""");
  }

  Future<Database> connect() async {
    String appPath = await getDatabasesPath();
    String path = join(appPath, "$_userDBPath.db");
    Database db = await openDatabase(path, version: _version, onCreate: _createDb);
    return db;
  }

  Future<List<UserModel>> getUser(String name) async {
    Database db = await _database;

    var res = name.length >= 2
        ? await db.query(_userDBPath, where: "name like ?", whereArgs: ["%$name%"])
        : await db.query(_userDBPath);

    List<UserModel> users = res.isNotEmpty ? res.map((e) => UserModel.fromJson(e)).toList() : [];
    return users;
  }

  Future<int> addUsers(UserModel user) async {
    Database db = await _database;

    return db.insert(_userDBPath, user.toJson());
  }

  Future<int> updateUser(UserModel user) async {
    Database db = await _database;
    return db.update(_userDBPath, user.toJson(), where: "id = ?", whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await _database;
    return db.delete(_userDBPath, where: "id = ?", whereArgs: [id]);
  }
}
