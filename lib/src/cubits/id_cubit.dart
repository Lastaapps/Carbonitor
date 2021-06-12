import 'package:carbonitor/src/cubits/measurement_cubit.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:timezone/standalone.dart';

class IdCubit extends MeasurementCubit {
  final String classId;

  IdCubit(this.classId);

  @override
  Future<Stream<List<Classroom>>> getStream() async {
    return repo.getClasses(ids: [classId]);
  }
}
