import 'dart:async';
import 'package:rxdart/rxdart.dart';

void main() async {
  print('Test 1: BehaviorSubject with sync: true');
  
  final subject1 = BehaviorSubject<int>.seeded(0, sync: true);
  
  var received1 = <int>[];
  subject1.stream.listen((value) {
    print('  Listener 1 received: $value');
    received1.add(value);
  });
  
  print('After listen setup, received: $received1');
  
  subject1.add(1);
  print('After add(1), received: $received1');
  
  await Future.delayed(Duration.zero);
  print('After delay, received: $received1');
  print('');
  
  print('Test 2: BehaviorSubject direct (not .stream)');
  
  final subject2 = BehaviorSubject<int>.seeded(0, sync: true);
  
  var received2 = <int>[];
  subject2.listen((value) {
    print('  Listener 2 received: $value');
    received2.add(value);
  });
  
  print('After listen setup, received: $received2');
  
  subject2.add(1);
  print('After add(1), received: $received2');
  
  await Future.delayed(Duration.zero);
  print('After delay, received: $received2');
}
