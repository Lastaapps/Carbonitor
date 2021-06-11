import 'package:carbonitor/src/constants/database.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/data/measurement.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:timezone/browser.dart';

class MeasurementDatabase {
  final BriteDatabase database;

  MeasurementDatabase._withDatabase(this.database);

  static Future<MeasurementDatabase> createInstance() async {
    return MeasurementDatabase._withDatabase(
        BriteDatabase(await _createDatabase()));
  }

  Future<void> insertMeasurements(List<Classroom> measurements) async {
    var batch = database.batch();
    for (var measurement in measurements) {
      batch.insert(measurementsTable, measurement.toDatabaseMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Stream<List<Classroom>> getAllMeasurement() {
    return database
        .createQuery(measurementsTable)
        .mapToList((row) => Measurement.fromDatabaseMap(row));
  }

  Stream<List<Classroom>> getDonutsBy(
      {List<int>? ids, TZDateTime? start, TZDateTime? end}) {
    String whereQuery = "";
    List<Object>? whereArgs;

    if (ids != null) {
      whereQuery += '"id = ? "';
      whereArgs = ids;
    }

    final startTimeTemp = start?.millisecondsSinceEpoch;
    final endTimeTemp = end?.millisecondsSinceEpoch;
    final startTime = startTimeTemp != null ? startTimeTemp / 1000 : null;
    final endTime = endTimeTemp != null ? endTimeTemp / 1000 : null;

    if (startTime != null && endTime != null) {
      whereQuery += '"time BETWEEN $startTime AND $endTime"';
    } else if (startTime != null && endTime == null) {
      whereQuery += '"time >= $startTime"';
    } else if (startTime == null && endTime != null) {
      whereQuery += '"time <= $endTime"';
    } else {}

    return database
        .createQuery(measurementsTable, where: whereQuery, whereArgs: whereArgs)
        .mapToList((row) => Measurement.fromDatabaseMap(row));
  }

  void deleteDonuts(List<int> ids) async {
    await database.delete(donutTableName, where: '"id" = ?', whereArgs: ids);
  }
}

//TODO crate database
Future<Database> _createDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), '$databaseName.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE $measurementsTable(time INTEGER PRIMARY KEY, temp DOUBLE, signal DOUBLE, hum DOUBLE, co2 DOUBLE, bat INTEGER, classId TEXT)',
      );
      await db.execute(
        'CREATE TABLE $classroomTable(id TEXT PRIMARY KEY, name TEXT)',
      );
      await db.execute(
        'CREATE TABLE $lessonTable(start INTEGER PRIMARY KEY classId TEXT PRIMARY KEY)',
      );
      await db.execute(
        'CREATE TABLE $teacherTable(id TEXT PRIMARY KEY, name TEXT)',
      );
    },
    version: 1,
  );
  return database;
}
