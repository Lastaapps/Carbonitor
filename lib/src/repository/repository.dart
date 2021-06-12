import 'dart:async';

import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/database/database.dart';
import 'package:carbonitor/src/extensions/streams/state_stream.dart';
import 'package:carbonitor/src/network_service/backend_service.dart';
import 'package:carbonitor/src/repository/new_data_processor.dart';
import 'package:carbonitor/src/repository/repository_state.dart';
import 'package:timezone/timezone.dart';

class MeasurementRepository {
  static final _repoInstance = MeasurementRepository._internal();
  late final MeasurementDatabase _database;

  final isReady = StateStreamController(false);

  final _repoStateStreamController =
      StateStreamController(RepositoryState(false, false));

  Stream<RepositoryState> get repoStateStream =>
      _repoStateStreamController.stream;

  MeasurementRepository._internal() {
    print("Initializing Repo");

    _initialize();
  }

  factory MeasurementRepository() {
    return _repoInstance;
  }

  void _initialize() async {
    _database = await MeasurementDatabase.createInstance();

    print("Repo initialized");
    isReady.add(true);
  }

  Future<void> fetchData() async {
    await isReady.stream.firstWhere((element) => element == true);

    //TODO handle errors
    final classrooms = await BackendService().fetchData();
    await _database.insertClasses(classrooms);

    NewDataProcessor.processNewData(classrooms);
  }

  Stream<List<Classroom>> getClasses(
      {List<String>? ids, TZDateTime? start, TZDateTime? end}) {
    return _database.getClassesBy(ids: ids, start: start, end: end);
  }
}
