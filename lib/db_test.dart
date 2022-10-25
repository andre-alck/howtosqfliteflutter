import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(
      await getDatabasesPath(),
      'doggies_database.db',
    ),
    onCreate: (
      db,
      version,
    ) {
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    version: 1,
  );

  Future<void> insertDog(
    Dog dog,
  ) async {
    final db = await database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dogs',
    );

    return List.generate(
      maps.length,
      (
        index,
      ) {
        return Dog(
          id: maps[index]['id'],
          name: maps[index]['name'],
          age: maps[index]['age'],
        );
      },
    );
  }

  Future<void> updateDog(
    Dog dog,
  ) async {
    final db = await database;
    await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [
        dog.id,
      ],
    );
  }

  var bidu = const Dog(
    id: 1,
    name: 'Bidu',
    age: 7,
  );

  await insertDog(
    bidu,
  );

  print(
    await dogs(),
  );

  bidu = Dog(
    id: bidu.id + 1,
    name: bidu.name,
    age: bidu.age,
  );

  await updateDog(
    bidu,
  );

  print(
    bidu,
  );
}

class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
