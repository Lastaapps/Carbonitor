import 'dart:async';

import 'package:carbonitor/src/constants/database.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/data/measurement.dart';
import 'package:carbonitor/src/extensions/streams/merge_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:timezone/timezone.dart';

class MeasurementDatabase {
  final BriteDatabase database;

  MeasurementDatabase._withDatabase(this.database);

  static Future<MeasurementDatabase> createInstance() async {
    return MeasurementDatabase._withDatabase(
        BriteDatabase(await _createDatabase()));
  }

  Future<void> insertClasses(List<Classroom> classrooms) async {

    print("Inserting ${classrooms.length} classrooms");

    for (var classroom in classrooms) {
      database.insert(classroomTable, classroom.toDatabaseMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    var batch = database.batch();
    for (var classroom in classrooms) {
      print("Inserting ${classroom.measurements.length} measurements");
      for (var measurement in classroom.measurements) {
        batch.insert(measurementsTable, measurement.toDatabaseMap(classroom.id),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
    await batch.commit();
  }

  // Future<void> insertMeasurements(List<Measurement> measurements) async {
  //   var batch = database.batch();
  //
  //     for (var measurement in measurements) {
  //       batch.insert(measurementsTable, measurement.toDatabaseMap(classroom.id),
  //           conflictAlgorithm: ConflictAlgorithm.replace);
  //     }
  //
  //   await batch.commit();
  // }

  Stream<List<Measurement>> getAllMeasurement() {
    return database
        .createQuery(measurementsTable)
        .mapToList((row) => Measurement.fromDatabaseMap(row));
  }

  Stream<List<Classroom>> getClassesBy(
      {List<String>? ids, TZDateTime? start, TZDateTime? end}) {
    String whereQuery = "";
    List<Object>? whereArgs;

    if (ids != null) {
      whereQuery += '"classId" = ? ';
      whereArgs = ids;
    }

    final startTimeTemp = start?.millisecondsSinceEpoch;
    final endTimeTemp = end?.millisecondsSinceEpoch;
    final startTime = startTimeTemp != null ? startTimeTemp / 1000 : null;
    final endTime = endTimeTemp != null ? endTimeTemp / 1000 : null;

    if (startTime != null && endTime != null) {
      whereQuery += '"time" BETWEEN $startTime AND $endTime';
    } else if (startTime != null && endTime == null) {
      whereQuery += '"time" >= $startTime';
    } else if (startTime == null && endTime != null) {
      whereQuery += '"time" <= $endTime';
    } else {}

    final measureStream = database.createQuery(measurementsTable,
        where: whereQuery != "" ? whereQuery : null,
        whereArgs: whereQuery != "" ? whereArgs : null,
        orderBy: 'time');

    final classroomStream = ids != null
        ? database.createQuery(classroomTable,
            where: '"id" = ?', whereArgs: ids, orderBy: 'name')
        : database.createQuery(classroomTable, orderBy: 'name');

    final merged = MergeStream([
      measureStream.mapToList((row) => row),
      classroomStream.mapToList((row) => row),
      getAllMeasurement(),
    ]);

    final outputStream =
        StreamController<List<Classroom>>(onCancel: () => merged.close());

    merged.stream.then((stream) => stream.listen((objects) {
          final measures = objects[0] as List<Map<String, Object?>>;
          final classRooms = objects[1] as List<Map<String, Object?>>;

          print("Merging in database $measures $classRooms");

          final mapped = classRooms.map((e) {
            final id = e["id"];

            final filtered = List.of(measures);
            filtered.retainWhere((element) => element["classId"] == id);
            final mapped =
                filtered.map((e) => Measurement.fromDatabaseMap(e)).toList();

            return Classroom.fromDatabaseMap(e, mapped);
          });

          outputStream.add(mapped.toList());
        }));

    return outputStream.stream;
  }
}

Future<Database> _createDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), '$databaseName.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE $measurementsTable(key TEXT PRIMARY KEY, time INTEGER, temp REAL, signal REAL, hum REAL, co2 DOUBLE, bat INTEGER, classId TEXT)',
      );
      await db.execute(
        'CREATE TABLE $classroomTable(id TEXT PRIMARY KEY, name TEXT)',
      );
      await db.execute(
        'CREATE TABLE $lessonTable(start INTEGER, classId TEXT, PRIMARY KEY (start, classId))', //NOT WORKING KEYS
      );
      await db.execute(
        'CREATE TABLE $teacherTable(id TEXT PRIMARY KEY, name TEXT)',
      );
    },
    version: 1,
  );
  return database;
}
