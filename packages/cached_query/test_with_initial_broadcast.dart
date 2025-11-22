import 'dart:async';

extension WithInitialExtension<T> on Stream<T> {
  Stream<T> withInitial(T initialValue, {bool sync = true}) {
    final controller = StreamController<T>.broadcast(sync: sync);  // Changed to broadcast
    StreamSubscription<T>? subscription;

    controller.onListen = () {
      controller.add(initialValue);
      subscription = listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
    };
    controller.onCancel = () => subscription?.cancel();

    return controller.stream;
  }
}

void main() async {
  print('Test: withInitial with broadcast controller');
  
  final sourceController = StreamController<int>.broadcast(sync: true);
  final streamWithInitial = sourceController.stream.withInitial(0);
  
  var received = <int>[];
  print('Before listen');
  streamWithInitial.listen((value) {
    print('  Received: $value');
    received.add(value);
  });
  print('After listen, received: $received');
  
  sourceController.add(1);
  print('After add(1), received: $received');
}
