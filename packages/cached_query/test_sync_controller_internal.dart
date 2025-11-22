import 'dart:async';

void main() async {
  print('Test: Emitting from onListen in a sync:true broadcast controller');
  
  // Create the exact pattern BehaviorSubject uses
  final innerController = StreamController<int>.broadcast(sync: true);
  final outerController = StreamController<int>.broadcast(sync: true);
  
  outerController.onListen = () {
    print('  onListen fired');
    // Emit initial value
    outerController.add(99);
    // Then subscribe to inner
    innerController.stream.listen(outerController.add);
  };
  
  var received = <int>[];
  print('Before listen');
  outerController.stream.listen((value) {
    print('  Listener received: $value');
    received.add(value);
  });
  print('After listen, received: $received');
  
  innerController.add(1);
  print('After innerController.add(1), received: $received');
  
  await Future.delayed(Duration.zero);
  print('After delay, received: $received');
}
