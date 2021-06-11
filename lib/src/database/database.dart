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
    var batch = database.batch();

    for (var classroom in classrooms) {
      batch.insert(classroomTable, classroom.toDatabaseMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

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

    final measureStream = database.createQuery(measurementsTable,
        where: whereQuery, whereArgs: whereArgs);
    final classroomStream = ids != null
        ? database.createQuery(classroomTable,
            where: '"id" = ?', whereArgs: ids)
        : database.createQuery(classroomTable);

    final merged = MergeStream([measureStream, classroomStream]);

    final outputStream =
        StreamController<List<Classroom>>(onCancel: () => merged.close());

    merged.stream.then((stream) => stream.listen((objects) {
          final measures = objects[0] as List<Map<String, Object>>;
          final classRooms = objects[1] as List<Map<String, Object>>;

          classRooms.map((e) {
            final id = e["id"];

            final filtered = List.of([...measures]);
            measures.retainWhere((element) => element["id"] == id);
            final mapped =
                filtered.map((e) => Measurement.fromDatabaseMap(e)).toList();

            return Classroom.fromDatabaseMap(e, mapped);
          });
        }));

    return outputStream.stream;
  }
}

//TODO crate database
Future<Database> _createDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), '$databaseName.db'),
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE $measurementsTable(time INTEGER, temp REAL, signal REAL, hum REAL, co2 DOUBLE, bat INTEGER, classId TEXT, PRIMARY KEY (time, classId))',
      );
      await db.execute(
        'CREATE TABLE $classroomTable(id TEXT PRIMARY KEY, name TEXT)',
      );
      await db.execute(
        'CREATE TABLE $lessonTable(start INTEGER, classId TEXT, PRIMARY KEY (start, classId))',
      );
      await db.execute(
        'CREATE TABLE $teacherTable(id TEXT PRIMARY KEY, name TEXT)',
      );
    },
    version: 1,
  );
  return database;
}
