import 'package:carbonitor/src/data/measurement.dart';

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
