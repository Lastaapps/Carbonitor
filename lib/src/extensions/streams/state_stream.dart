import 'dart:async';

class StateStreamController<T> {
  final _controller = StreamController<T>();
  late final Stream<T> _sourceStream = _controller.stream.asBroadcastStream();
  T state;

  StateStreamController(this.state);

  Stream<T> get stream {
    late final StreamSubscription<T> subscription;

    // ignore: close_sinks
    late final StreamController<T> controller;
    controller = StreamController<T>(onListen: () {
      controller.add(state);
      subscription.resume();
    }, onPause: () {
      subscription.pause();
    }, onResume: () {
      subscription.resume();
    }, onCancel: () {
      subscription.cancel();
    });

    subscription = _sourceStream.listen((state) {
      controller.add(state);
    });
    subscription.pause();

    return controller.stream;
  }

  void add(T state) {
    this.state = state;
    _controller.add(state);
  }

  void close() {
    _controller.close();
  }
}
