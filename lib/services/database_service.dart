import 'dart:async';

import 'package:codexia_academys/model/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  static String tableName = 'student';

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String dbName = 'school.db';
    String path = join(dbPath, dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(
          'CREATE TABLE $tableName ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, '
          'fName TEXT, '
          'village TEXT, '
          'fee INTEGER, '
          'paidFee INTEGER, '
          'pendingFee INTEGER, '
          'joinDate TEXT,'
          'image TEXT'
          ')',
        );
      },
    );
  }

  Future insertStudent(StudentModel student) async {
    Database database = await getDatabase();
    await database.rawInsert(
      'INSERT INTO $tableName (name, fName, fee, village, paidFee, pendingFee, joinDate,image) '
      'VALUES (?, ?, ?, ?, ?, ?, ?,?)',
      [
        student.name,
        student.fName,
        student.fees,
        student.village,
        student.paidFee,
        student.pendingFee,
        student.joinDate,
        student.image
      ],
    );
  }

  Future<List<StudentModel>> fetchStudents() async {
    Database database = await getDatabase();
    List<Map<String, dynamic>> mapList =
        await database.rawQuery('select * from $tableName');
    List<StudentModel> studentModelList = [];
    for (int i = 0; i < mapList.length; i++) {
      studentModelList.add(StudentModel.fromMap(mapList[i]));
    }
    return studentModelList;
  }

  Future<int> updateStudent(StudentModel student) async {
    Database database = await getDatabase();
    String sql = '''
      UPDATE $tableName 
      SET name = ?, fName = ?, village = ? ,fee = ?,pendingFee = ?,paidFee = ?,joinDate = ?
      WHERE id = ?
    ''';
    return await database.rawUpdate(sql, [
      student.name,
      student.fName,
      student.village,
      student.paidFee,
      student.pendingFee,
      student.joinDate,
      student.fees,
      student.id,
    ]);
  }

  static Future<int> deleteStudent(int id) async {
    Database database = await getDatabase();
    String sql = 'delete from $tableName where id = ?';
    return await database.rawDelete(sql, [id]);
  }

  addStudent(StudentModel student) {}
}
