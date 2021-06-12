class Lesson {
  final DateTime start;
  late final DateTime end;
  final String classroomId;

  Lesson({required this.classroomId, required this.start}) {
    end = start.add(Duration(minutes: 45));
  }

}
