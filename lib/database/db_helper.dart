import 'dart:io';
import 'package:flutter_sqflite/data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
//  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'sqfliteuser.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sqfliteuser(
          id INTEGER PRIMARY KEY,
          name TEXT,
          address TEXT,
          phone TEXT,
          imagepath TEXT
      )
      ''');
  }


  Future<List<UserData>> getSqfliteuser() async {
    Database db = await instance.database;
    var sqfliteuser = await db.query('sqfliteuser', orderBy: 'id');
   // print(sqfliteuser);   
   // print(sqfliteuser[0]['name']);   
    
    
    List<UserData> sqfliteuserList = sqfliteuser.isNotEmpty
        ? sqfliteuser.map((c) => UserData.fromMap(c)).toList()
        : [];
    return sqfliteuserList;
  }

  Future<int> add(UserData sqfliteuserList) async {
    Database db = await instance.database;
    return await db.insert('sqfliteuser', sqfliteuserList.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('sqfliteuser', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(UserData sqfliteuserList) async {
    Database db = await instance.database;
    return await db.update('sqfliteuser', sqfliteuserList.toMap(),
        where: "id = ?", whereArgs: [sqfliteuserList.id]);
  }
}
