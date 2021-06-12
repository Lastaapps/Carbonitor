import 'package:carbonitor/src/constants/concentrations.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/notifiaction/notification_service.dart';

class NewDataProcessor {
  static Future<void> processNewData(List<Classroom> classes) async {
    print("Processing new data");

    final classId = classes[0].id; //mock id

    classes.forEach((element) {
      if (true && element.id == classId) {
        //mock true
        element.measurements.forEach((element) {
          if (element.carbon > Concentrations.tiredness.concentration) {
            NotificationService().warn();
            return;
          }
        });
      }
    });
  }
}
