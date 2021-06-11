import 'dart:async';

import 'package:carbonitor/src/extensions/streams/state_stream.dart';

class MergeStream {
  final List<Stream<dynamic>> _streams;
  final _subscriptions = List<StreamSubscription>.empty(growable: true);
  StateStreamController<List<dynamic>>? _controller = null;

  final _isReady = StateStreamController(false);

  MergeStream(this._streams) {
    _init();
  }

  static const _placeholder = Object();

  void _init() async {
    var list = List.generate(_streams.length, (index) => _placeholder);

    for (var i = 0; i < _streams.length; i++) {
      final stream = _streams[i];
      final subscription = stream.listen((event) {
        final newList = List.of([...list]);

        newList[i] = event;
        list = newList;

        if (!list.contains(_placeholder)) {
          if (_controller == null)
            _controller = StateStreamController(newList);
          else
            _controller!.add(list);

          _isReady.add(true);
        }
      });
      _subscriptions.add(subscription);
    }
  }

  Future<Stream<List<dynamic>>> get stream async {
    await _isReady.stream.firstWhere((element) => element == true);
    return _controller!.stream;
  }

  void close() {
    _controller?.close();
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}
