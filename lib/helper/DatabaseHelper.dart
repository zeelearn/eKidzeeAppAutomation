import 'dart:async';

import 'package:ekidzee/helper/DBConstant.dart';
import 'package:ekidzee/helper/LocalConstant.dart';
import 'package:ekidzee/helper/sqflite_init.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:ekidzee/model/parent_info.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 */
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  var _db;

  static String CREATE_TABLE_NOTIFICATION =
      'CREATE TABLE ${LocalConstant.TABLE_NOTIFICATION}'
      '(notification_id TEXT PRIMARY KEY, '
      'title TEXT, '
      'description TEXT, '
      'type TEXT, '
      'imageurl TEXT, '
      'logoUrl TEXT, '
      'bigImageUrl TEXT, '
      'webViewLink TEXT, '
      'date TEXT)';

  static String CREATE_TABLE_PARENT_INFO =
      'CREATE TABLE ${LocalConstant.TABLE_PARENT_INFO}'
      '(_id TEXT PRIMARY KEY, '
      '${DBConstant.FRANCHISEE_ID} INT, '
      '${DBConstant.STUDENT_PROGRAM_ID} INT, '
      '${DBConstant.STUDENT_ID} INT, '
      '${DBConstant.CLASS_ID} INT, '
      '${DBConstant.PARENT_ID} INT, '
      '${DBConstant.PARENT_NAME} TEXT, '
      '${DBConstant.CLASS_NAME} TEXT, '
      '${DBConstant.STUDENT_DOB} TEXT, '
      '${DBConstant.IS_PARENT_VERIFY} TEXT, '
      '${DBConstant.ADDRESS} TEXT, '
      '${DBConstant.ADDRESS_ALT} TEXT, '
      '${DBConstant.PHONE_NUMBER} TEXT, '
      '${DBConstant.MOBILE_NUMBER} TEXT, '
      '${DBConstant.MAIL_ADDRESS} TEXT, '
      '${DBConstant.STATE} TEXT, '
      '${DBConstant.CITY} TEXT, '
      '${DBConstant.PLACE} TEXT, '
      '${DBConstant.STUDENT_NAME} TEXT, '
      '${DBConstant.STUDENT_GENDER} TEXT, '
      '${DBConstant.SCHOOL_NAME} TEXT, '
      '${DBConstant.PROGRAM_NAME} TEXT, '
      '${DBConstant.ADMISSION_DATE} TEXT, '
      '${DBConstant.FRANS_TYPE} TEXT, '
      '${DBConstant.STUDENT_AVTAR} TEXT, '
      '${DBConstant.DATE} TEXT)';

  static String CREATE_TABLE_BACKGROUND_SYNC =
      'CREATE TABLE IF NOT EXISTS  ${LocalConstant.TABLE_DATA_SYNC}'
      '(${DBConstant.ID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      '${DBConstant.JSON_MODEL} INT, '
      '${DBConstant.ACTION_TYPE} TEXT, '
      '${DBConstant.IS_SYNC} int, '
      '${DBConstant.USER_ID} TEXT, '
      'logoUrl TEXT, '
      'bigImageUrl TEXT, '
      'webViewLink TEXT, '
      '${DBConstant.DATE} TEXT)';

  Future<sql.Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DBHelper._internal();

  static const String _webDatabaseName = 'ekidzee.db';

  static Future<Future<sql.Database>> initDb() async {
    await initSqflitePlatform();

    final String databasePath;
    if (kIsWeb) {
      databasePath = _webDatabaseName;
    } else {
      final dbPath = await sql.getDatabasesPath();
      databasePath = path.join(dbPath, _webDatabaseName);
    }

    // open if found, create if not found for db
    return sql.openDatabase(databasePath, onCreate: (db, version) {
      db.execute(CREATE_TABLE_PARENT_INFO);
      db.execute(CREATE_TABLE_NOTIFICATION);
      db.execute(CREATE_TABLE_BACKGROUND_SYNC);
    }, onUpgrade: (db, old, newversion) async {
//       debugPrint('Database Upgrade-------------------');
      if (old <= 2) {
        db.execute(CREATE_TABLE_BACKGROUND_SYNC);
        await db.execute(
            'ALTER TABLE ${LocalConstant.TABLE_NOTIFICATION} ADD COLUMN logoUrl TEXT');
        await db.execute(
            'ALTER TABLE ${LocalConstant.TABLE_NOTIFICATION} ADD COLUMN bigImageUrl TEXT');
        await db.execute(
            'ALTER TABLE ${LocalConstant.TABLE_NOTIFICATION} ADD COLUMN webViewLink TEXT');
      }
    }, version: 4);
  }

  /// insert data to db
  /// @param table: the name of the table to insert to
  /// @param data: data map to be inserted
  Future<void> insert(String table, Map<String, Object> data) async {
    final dbClient = await db;
    dbClient.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /// delete data to db
  /// @param table: the name of the table to delete from
  /// @param id: product id to be deleted
  Future<void> delete(String table, String id) async {
    final dbClient = await db;
    dbClient.delete(table, where: '${DBConstant.ID} = ?', whereArgs: [id]);
  }

  /// delete data to db
  /// @param table: the name of the table to delete from
  /// @param id: product id to be deleted
  Future<void> deleteData(String table) async {
    final dbClient = await db;
    dbClient.delete(table, where: '', whereArgs: []);
  }

  Future<void> deleteNotification({
    required String title,
    required String date,
  }) async {
    final dbClient = await db;
    await dbClient.delete(
      LocalConstant.TABLE_NOTIFICATION,
      where: 'title = ? AND date = ?',
      whereArgs: [title, date],
    );
  }

  /// update data in db
  /// @param table: the name of the table to be updated
  /// @param data: data map to be updated
  Future<void> update(String table, Map<String, Object> data) async {
    final dbClient = await db;
    dbClient.update(table, data);
  }

  /// select data from db
  /// @param table: the name of the table to fetch data from
  /// @return Future of the list of products data
  Future<List<Map<String, dynamic>>> getData(String table) async {
    final dbClient = await db;
    return await dbClient.query(table);
  }

  /// clear database
  Future clear() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(dbPath);
  }

  Future<ParentInfo> getParentInfo() async {
    List<ParentInfo> parentInfoList = [];
    List<Map<String, dynamic>> list =
        await DBHelper().getData(LocalConstant.TABLE_PARENT_INFO);
    for (int index = 0; index < list.length; index++) {
      Map<String, dynamic> map = list[index];

      parentInfoList.add(ParentInfo(
          franchiseeId: map[DBConstant.FRANCHISEE_ID],
          studentProgramId: map[DBConstant.STUDENT_PROGRAM_ID],
          studentID: map[DBConstant.STUDENT_ID],
          classId: map[DBConstant.CLASS_ID],
          className: map[DBConstant.CLASS_NAME],
          parentID: map[DBConstant.PARENT_ID],
          parentName: map[DBConstant.PARENT_NAME],
          studentDOB: map[DBConstant.STUDENT_DOB],
          isParentVerified: map[DBConstant.IS_PARENT_VERIFY],
          address1: map[DBConstant.ADDRESS],
          address2: map[DBConstant.ADDRESS_ALT],
          phoneNumber: map[DBConstant.PHONE_NUMBER],
          mobileNo: map[DBConstant.MOBILE_NUMBER],
          emailId: map[DBConstant.MAIL_ADDRESS],
          stateName: map[DBConstant.STATE],
          cityName: map[DBConstant.CITY],
          place: map[DBConstant.PLACE],
          studentName: map[DBConstant.STUDENT_NAME],
          studentGender: map[DBConstant.STUDENT_GENDER],
          schoolName: map[DBConstant.SCHOOL_NAME],
          programName: map[DBConstant.PROGRAM_NAME],
          admissionDate: map[DBConstant.ADMISSION_DATE],
          franchiseeType: map[DBConstant.FRANS_TYPE],
          studentExtraSmallImage: map[DBConstant.STUDENT_AVTAR],
          studentSmallImage: map[DBConstant.STUDENT_AVTAR],
          studentMediumImage: map[DBConstant.STUDENT_AVTAR],
          studentLargeImage: map[DBConstant.STUDENT_AVTAR]));
    }
    return parentInfoList[0];
  }

  Future<List<ParentInfo>> getParentInfoList() async {
    List<ParentInfo> parentInfoList = [];
    List<Map<String, dynamic>> list =
        await DBHelper().getData(LocalConstant.TABLE_PARENT_INFO);
    for (int index = 0; index < list.length; index++) {
      Map<String, dynamic> map = list[index];

      parentInfoList.add(ParentInfo(
          franchiseeId: map[DBConstant.FRANCHISEE_ID],
          studentProgramId: map[DBConstant.STUDENT_PROGRAM_ID],
          studentID: map[DBConstant.STUDENT_ID],
          classId: map[DBConstant.CLASS_ID],
          className: map[DBConstant.CLASS_NAME],
          parentID: map[DBConstant.PARENT_ID],
          parentName: map[DBConstant.PARENT_NAME],
          studentDOB: map[DBConstant.STUDENT_DOB],
          isParentVerified: map[DBConstant.IS_PARENT_VERIFY],
          address1: map[DBConstant.ADDRESS],
          address2: map[DBConstant.ADDRESS_ALT],
          phoneNumber: map[DBConstant.PHONE_NUMBER],
          mobileNo: map[DBConstant.MOBILE_NUMBER],
          emailId: map[DBConstant.MAIL_ADDRESS],
          stateName: map[DBConstant.STATE],
          cityName: map[DBConstant.CITY],
          place: map[DBConstant.PLACE],
          studentName: map[DBConstant.STUDENT_NAME],
          studentGender: map[DBConstant.STUDENT_GENDER],
          schoolName: map[DBConstant.SCHOOL_NAME],
          programName: map[DBConstant.PROGRAM_NAME],
          admissionDate: map[DBConstant.ADMISSION_DATE],
          franchiseeType: map[DBConstant.FRANS_TYPE],
          studentExtraSmallImage: map[DBConstant.STUDENT_AVTAR],
          studentSmallImage: map[DBConstant.STUDENT_AVTAR],
          studentMediumImage: map[DBConstant.STUDENT_AVTAR],
          studentLargeImage: map[DBConstant.STUDENT_AVTAR]));
    }
    return parentInfoList;
  }

  Future<void> updateCheckInStatus(int id, int isSync) async {
    var dbclient = await db;
    await dbclient.rawUpdate(
        'update ${LocalConstant.TABLE_DATA_SYNC} set ${DBConstant.IS_SYNC} = \'$isSync\'  where id=$id');
  }

  Future<void> insertSyncData(String json, String action, int userid) async {
    var dbclient = await db;
    Map<String, Object> data = {
      DBConstant.JSON_MODEL: json,
      DBConstant.ACTION_TYPE: action,
      DBConstant.IS_SYNC: 0,
      DBConstant.USER_ID: userid,
      DBConstant.DATE: Utility.formatDate(),
    };
    await dbclient.insert(LocalConstant.TABLE_DATA_SYNC, data);
  }

  Future<List<Map<String, dynamic>>> getUnSyncData(String userId) async {
    List<Map<String, dynamic>> unSyncList = [];
    List<Map<String, dynamic>> list =
        await DBHelper().getData(LocalConstant.TABLE_DATA_SYNC);
    for (int index = 0; index < list.length; index++) {
      Map<String, dynamic> map = list[index];
      if (map[DBConstant.IS_SYNC] == 0) {
        unSyncList.add(map);
      }
    }
    return unSyncList;
  }
}
