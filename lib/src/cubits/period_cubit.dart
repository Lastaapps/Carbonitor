import 'package:carbonitor/src/cubits/measurement_cubit.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:timezone/standalone.dart';

class PeriodCubit extends MeasurementCubit {
  TZDateTime? start;
  TZDateTime? end;

  PeriodCubit({this.start, this.end});

  @override
  Future<Stream<List<Classroom>>> _getStream() async {
    return repo.getClasses(start: start, end: end);
  }
}
