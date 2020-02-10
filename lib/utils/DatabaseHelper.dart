import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:madhusudan/common/ClassList.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton DatabaseHelper

  //===================  Basic Query Example  =========================
  //var result = await db.rawQuery('Select * from $noteTable order by $Name ASC');
  //var result = await db.rawQuery('Select * from $noteTable order by $Name ASC');

  //========================  DATABASE  CREATION  ================================
  String tbl_PhotoOpenCount = "PhotoOpenCount";
  String Id = "Id";

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); //this is executed only once
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the default path of both android & ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'madhusudan.db';

    //open/create database at given path
    var madhusudanDatabase =
        await openDatabase(path, version: 1, onCreate: _CreateDb);
    return madhusudanDatabase;
  }

  void _CreateDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $tbl_PhotoOpenCount(MemberId INTEGER, PhotoId INTEGER, Count INTEGER)',
    );
  }

  //========================  Database  CRUD  OPERATIONS  ================================

  //=================  PhotoOpenCount Table Code  ===================
  //Insert Into Table
  Future<int> insertPhotoOpenCount(PhotoOpenCountClass photoOpenCount) async {
    Database db = await this.database;
    var result = await db.insert(tbl_PhotoOpenCount, photoOpenCount.toMap());
    return result;
  }

  //Bulk Insert Into Table
  Future<int> insertBulkPhotoOpenCount(
      List<PhotoOpenCountClass> photoOpenCountList) async {
    Database db = await this.database;
    int count = photoOpenCountList.length;

    if (count > 0) {
      await db.rawQuery('delete from $tbl_PhotoOpenCount');
    }

    for (int i = 0; i < count; i++) {
      await db.insert(tbl_PhotoOpenCount, photoOpenCountList[i].toMap());
    }

    List<Map<String, dynamic>> x =
        await db.rawQuery('Select count(*) from $tbl_PhotoOpenCount');
    var result = Sqflite.firstIntValue(x);

    return result;
  }

  //Update Operation
  Future<int> updatePhotoOpenCount(PhotoOpenCountClass photoOpenCount) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
      "Update $tbl_PhotoOpenCount set Count = Count+1 where MemberId = ? and PhotoId = ?",
      [photoOpenCount.MemberId, photoOpenCount.PhotoId],
    );
    return result;
  }

  //List From Table
  Future<List<Map<String, dynamic>>> getPhotoOpenCountMapList(
      String photoId) async {
    Database db = await this.database;
    String qry = "select * from $tbl_PhotoOpenCount where PhotoId = '$photoId'";
    var result = await db.rawQuery(qry);
    return result;
  }

  Future<List<PhotoOpenCountClass>> getPhotoOpenCountList(
      String photoId) async {
    var photoOpenCountMapList = await getPhotoOpenCountMapList(photoId);
    int count = photoOpenCountMapList.length;

    List<PhotoOpenCountClass> photoOpenCountList = List<PhotoOpenCountClass>();

    for (int i = 0; i < count; i++) {
      PhotoOpenCountClass newData = new PhotoOpenCountClass(
        MemberId: photoOpenCountMapList[i]["MemberId"].toString(),
        PhotoId: photoOpenCountMapList[i]["PhotoId"].toString(),
        Count: photoOpenCountMapList[i]["Count"].toString(),
      );
      photoOpenCountList.add(newData);
      //photoOpenCountList.add(PhotoOpenCountClass.fromMapObject(photoOpenCountMapList[i]));
    }
    return photoOpenCountList;
  }
}
