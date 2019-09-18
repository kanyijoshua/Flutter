import 'package:myapp/sqlite/employee.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'dart:async';

class Dbhelper {
  static Future<Database> _db;
  static const String ID="id";
  static const String NAME = "name";
  static const String TABLE = "Employee";
  static const String DB_NAME = "employee.db";

  Future<Database> get db async{
    if (_db!= null) {
      return _db;
    }
    _db =initDb();
    return _db;
  }
  Future<Database>initDb()async{
    //io.Directory documentdr= await getApplicationDocumentsDirectory();
    String path= join(await getDatabasesPath(), DB_NAME);
    Future<Database> db = openDatabase(path,version: 1, onCreate: _onCreate);
    return db;
  }
  _onCreate(Database db,int version)async{
    await db.execute("CREATE TABLE $TABLE($ID INTEGER PRIMARY KEY, $NAME TEXT)");
  }

  // final Future<Database> database = openDatabase(
  // // Set the path to the database. 
  // join(await getDatabasesPath(), 'doggie_database.db'),
  //   // When the database is first created, create a table to store dogs.
  //   onCreate: (db, version) {
  //     // Run the CREATE TABLE statement on the database.
  //     return db.execute(
  //       "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
  //     );
  //   },
  //   // Set the version. This executes the onCreate function and provides a
  //   // path to perform database upgrades and downgrades.
  //   version: 1,
  // );

  Future<Employee>save(Employee emply) async{
    var dbclent = await db;
    emply.id = await dbclent.insert(TABLE, emply.tomap());
    return emply;
  }
  Future<List<Employee>>getEmployees() async{
    var dbclent = await db;
    List<Map> map = await dbclent.query(TABLE, columns: [ID,NAME]);
    List<Employee> employees=[];
    if (map.length>0) {
      for (var i = 0; i < map.length; i++) {
        employees.add(Employee.fromMap(map[i]));
      }
    }
    return employees;
  }
  Future<int> delete(int id)async{
    var dbclient = await db;
    return await dbclient.delete(TABLE,where: '$ID=?',whereArgs: [id]);
  }
  Future<int> update(Employee empl)async{
    var dbclient = await db;
    return await dbclient.update(TABLE, empl.tomap(),where: '$ID=?',whereArgs: [empl.id]);
  }
  Future close()async{
    var dbclent= await db;
    dbclent.close();
  }
}