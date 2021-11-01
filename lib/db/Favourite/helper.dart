import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_helper.dart';

class DatabaseHandler{

  Future<Database> initializeDB() async {
    String dbpath = await getDatabasesPath();
    return openDatabase(join(dbpath, "favSongDb.db"),
      version: 1,
      onCreate: (database, version,) async {
      print("Creating favourite SONG");
        await database.execute(
          "CREATE TABLE users(num INTEGER PRIMARY KEY,name TEXT NOT NULL,location TEXT NOT NULL)",);
      },);
  }

  Future <int> insertFavSongs(List<Songs>users)async{
    int result =0;
    final Database db =await initializeDB();
    for(var user in users){
      result =await db.insert('users', user.toMap());
    }
    return result;
  }

  Future <List<Songs>>retrieveFavSongs()async{
    final Database db =await initializeDB();
    final List <Map<String,Object?>>queryResult=await db.query('users');
    debugPrint("UNAISEr: $queryResult");
    return queryResult.map((e) => Songs.fromMap(e)).toList();
  }

  Future<void> deleteFavSongs(int num) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "num = ?",
      whereArgs: [num],
    );
  }
}



