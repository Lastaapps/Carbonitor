import 'package:bloc/bloc.dart';
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

  const MeasurementData(bool isLoading, this.classrooms) : super(isLoading);
}
