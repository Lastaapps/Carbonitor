import 'package:bloc/bloc.dart';
import 'package:carbonitor/src/cubits/period_cubit.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/extensions/streams/merge_stream.dart';
import 'package:carbonitor/src/extensions/streams/state_stream.dart';
import 'package:carbonitor/src/repository/repository.dart';
import 'package:carbonitor/src/repository/repository_state.dart';
import 'package:meta/meta.dart';

import 'measurement_state.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

abstract class TodayCubit extends PeriodCubit {
  static final _zone = tz.local;

  static tz.TZDateTime get _now => tz.TZDateTime.now(_zone);

  static tz.TZDateTime get _morning =>
      tz.TZDateTime(_zone, _now.year, _now.month, _now.day);

  static tz.TZDateTime get _evening => tz.TZDateTime.fromMillisecondsSinceEpoch(
      _zone, _morning.millisecondsSinceEpoch + 24 * 3600 * 1000);

  TodayCubit() : super(start: _morning, end: _evening) {
    DateTime.now();
  }
}
