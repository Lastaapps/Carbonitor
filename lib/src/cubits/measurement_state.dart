import 'package:carbonitor/src/data/classroom.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MeasurementState {
  final bool isLoading;

  const MeasurementState(this.isLoading);
}

class MeasurementInitial extends MeasurementState {
  const MeasurementInitial(bool isLoading) : super(isLoading);
}

class MeasurementError extends MeasurementState {
  const MeasurementError(bool isLoading) : super(isLoading);
}

class MeasurementData extends MeasurementState {
  final List<Classroom> classrooms;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementData &&
          runtimeType == other.runtimeType &&
          classrooms == other.classrooms;

  @override
  int get hashCode => classrooms.hashCode;

  const MeasurementData(bool isLoading, this.classrooms) : super(isLoading);
}
