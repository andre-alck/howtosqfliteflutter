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
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER',
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

  const bidu = Dog(
    id: 1,
    name: 'Bidu',
    age: 7,
  );

  await insertDog(
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
