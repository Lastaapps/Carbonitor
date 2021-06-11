import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/extensions/streams/merge_stream.dart';
import 'package:carbonitor/src/extensions/streams/state_stream.dart';
import 'package:carbonitor/src/repository/repository.dart';
import 'package:carbonitor/src/repository/repository_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'measurement_state.dart';

abstract class MeasurementCubit extends Cubit<MeasurementState> {
  final repo = MeasurementRepository();
  late final MergeStream _merged;
  final _isReady = StateStreamController(false);

  MeasurementCubit() : super(MeasurementInitial(false)) {
    listedToRepo();
  }

  Future<void> listedToRepo() async {
    await repo.isReady.stream.firstWhere((element) => element == true);

    final stream = await _getStream();

    _merged = MergeStream([stream, repo.repoStateStream]);
    (await _merged.stream).listen((objects) {
      final list = objects[0] as List<Classroom>;
      final state = objects[1] as RepositoryState;

      final isLoading = state.isLoading;

      if (list.isEmpty) {
        if (!state.attempted) {
          emit(MeasurementInitial(isLoading));
        } else {
          emit(MeasurementError(isLoading));
        }
      } else {
        emit(MeasurementData(isLoading, list));
      }
    });

    _isReady.add(true);
  }

  Future<Stream<List<Classroom>>> _getStream();

  @override
  Future<void> close() {
    _merged.close();
    return super.close();
  }
}
