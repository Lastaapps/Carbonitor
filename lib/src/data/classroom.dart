import 'dart:math';

import 'package:carbonitor/src/data/measurement.dart';
import 'package:timezone/timezone.dart';

class Classroom {
  final String id;
  final String name;
  final List<Measurement> measurements;

  const Classroom({required this.id, required this.name, required this.measurements});

  Map<String, dynamic> toDatabaseMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  Classroom.fromDatabaseMap(Map<String, dynamic> map, List<Measurement> measurements)
      : id = map["id"],
        name = map["name"],
        measurements = measurements;

  Measurement latest(TZDateTime? time) {
    final actualTime = time != null ? time : TZDateTime.now(UTC);
    final seconds = actualTime.millisecondsSinceEpoch;
    for (var measurement in measurements.reversed) {
      if (measurement.time.millisecondsSinceEpoch <= seconds) {
        return measurement;
      }
    }
    if (measurements.isNotEmpty) return measurements.last;

    return Measurement.fake();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Classroom &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
