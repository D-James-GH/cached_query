import 'dart:async';
import 'package:rxdart/rxdart.dart';

void main() async {
  print('Test 1: When does onListen fire with regular StreamController?');
  final controller1 = StreamController<int>(sync: true);
  
  controller1.onListen = () {
    print('  onListen callback fired!');
    controller1.add(42);
  };
  
  print('Before listen');
  var received1 = <int>[];
  controller1.stream.listen((value) {
    print('  Listener received: $value');
    received1.add(value);
  });
  print('After listen, received: $received1');
  await Future.delayed(Duration.zero);
  print('After delay, received: $received1');
  
  print('');
  print('Test 2: BehaviorSubject internal - does it use onListen?');
  final subject = BehaviorSubject<int>(sync: true);
  
  print('Before listen');
  var received2 = <int>[];
  subject.listen((value) {
    print('  Subject listener received: $value');
    received2.add(value);
  });
  print('After listen, received: $received2');
  
  subject.add(1);
  print('After add, received: $received2');
}
