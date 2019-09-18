import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DogDbhelper {
  static Future<Database> _db;
  Future<Database> get database{
    if (_db!= null) {
      return _db;
    }
    _db =creatdogdb();
    return _db;
  }
  Future<Database> creatdogdb() async {
  Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    },
    version: 1,
  );
  return database;
  }
  Future<DogClass> insertDog(DogClass dog) async {
    Database db = await database;
    dog.id = await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(dog);
    return dog;
  }

  Future<List<DogClass>> dogs() async {
    Database db = await database;
    List<Map> map = await db.query('dogs', columns: ["id","name","age"]);
    List<DogClass> dogs=[];
    if (map.length>0) {
      for (var i = 0; i < map.length; i++) {
        dogs.add(DogClass.fromMap(map[i]));
      }
    }
    // List<Map<String, dynamic>> maps = await db.query('dogs', columns: ["id","name","age"]);
    // return List.generate(maps.length, (i) {
    //   return DogClass(
    //     id: maps[i]['id'],
    //     name: maps[i]['name'],
    //     age: maps[i]['age'],
    //   );
    // });
    return dogs;
  }

  Future<int> updateDog(DogClass dog) async {
    final db = await database;
    return await db.update('dogs',dog.toMap(),where: "id = ?",whereArgs: [dog.id],);
  }

  Future<void> deleteDog(int id) async {
    final db = await database;
    await db.delete('dogs',where: "id = ?",whereArgs: [id],);
  }

  var fido = DogClass(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  // await insertDog(fido);

  // // Print the list of dogs (only Fido for now).
  // print(await dogs());

  // // Update Fido's age and save it to the database.
  // fido = Dog(
  //   id: fido.id,
  //   name: fido.name,
  //   age: fido.age + 7,
  // );
  // await updateDog(fido);

  // // Print Fido's updated information.
  // print(await dogs());

  // // Delete Fido from the database.
  // await deleteDog(fido.id);

  // // Print the list of dogs (empty).
  // print(await dogs());

}


class DogClass {
  int id;
  String name;
  int age;

  DogClass({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
  DogClass.fromMap(Map<String, dynamic>map){
    id=map["id"];
    name=map["name"];
    age=map["age"];
  }
}