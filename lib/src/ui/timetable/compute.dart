import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/data/lesson.dart';
import 'package:timezone/standalone.dart';

List<Classroom> computeClassrooms(
    List<Classroom> classrooms, List<Lesson> lessons, TZDateTime? time) {
  final filtered = List.of(classrooms);
  final lessonIds = lessons.map((e) => e.classroomId);
  filtered.retainWhere((element) => lessonIds.contains(element.id));

  return filtered;
}
