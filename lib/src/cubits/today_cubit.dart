import 'package:carbonitor/src/cubits/period_cubit.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:timezone/timezone.dart' as tz;

class TodayCubit extends PeriodCubit {
  static final _zone = tz.local;

  static tz.TZDateTime get _now => tz.TZDateTime.now(_zone);

  static tz.TZDateTime get _morning =>
      tz.TZDateTime(_zone, _now.year, _now.month, _now.day, 0, 0, 0);

  static tz.TZDateTime get _evening => tz.TZDateTime.fromMillisecondsSinceEpoch(
      _zone, _morning.millisecondsSinceEpoch + 24 * 3600 * 1000);

  TodayCubit() : super(start: _morning, end: _evening);
}
