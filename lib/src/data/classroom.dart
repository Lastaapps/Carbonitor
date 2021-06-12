import 'package:carbonitor/src/data/measurement.dart';
import 'package:timezone/timezone.dart';

class Classroom {
  final String id;
  final String name;
  final List<Measurement> measurements;

  const Classroom(
      {required this.id, required this.name, required this.measurements});

  Map<String, dynamic> toDatabaseMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  Classroom.fromDatabaseMap(
      Map<String, dynamic> map, List<Measurement> measurements)
      : id = map["id"],
        name = map["name"],
        measurements = measurements;

  Measurement latest(TZDateTime? time) {
    final actualTime = time != null ? time : TZDateTime.now(UTC);
    final seconds = actualTime.millisecondsSinceEpoch;
    print("length: ${measurements.length}");
    print("seconcs: $seconds");
    for (var measurement in measurements.reversed) {
      print("time: ${measurement.time.millisecondsSinceEpoch}");
      if (measurement.time.millisecondsSinceEpoch <= seconds) {
        return measurement;
      }
    }
    return Measurement(
        time: TZDateTime.now(UTC),
        temperature: 0,
        signal: 0,
        humidity: 0,
        carbon: 0,
        bat: 0);
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
