import 'dart:async';
import 'package:rxdart/rxdart.dart';

void main() async {
  print('Test 1: BehaviorSubject() without seed - listen directly');
  final subject1 = BehaviorSubject<int>(sync: true);
  
  var received1 = <int>[];
  subject1.listen((value) {
    print('  Direct listener received: $value');
    received1.add(value);
  });
  
  print('After listen, received: $received1');
  subject1.add(1);
  print('After add(1), received: $received1');
  
  await subject1.close();
  print('');
  
  print('Test 2: BehaviorSubject() without seed - listen to .stream');
  final subject2 = BehaviorSubject<int>(sync: true);
  
  var received2 = <int>[];
  subject2.stream.listen((value) {
    print('  Stream listener received: $value');
    received2.add(value);
  });
  
  print('After listen, received: $received2');
  subject2.add(1);
  print('After add(1), received: $received2');
  
  await subject2.close();
  print('');
  
  print('Test 3: BehaviorSubject.seeded() - listen directly');
  final subject3 = BehaviorSubject<int>.seeded(0, sync: true);
  
  var received3 = <int>[];
  subject3.listen((value) {
    print('  Seeded direct listener received: $value');
    received3.add(value);
  });
  
  print('After listen, received: $received3');
  subject3.add(1);
  print('After add(1), received: $received3');
  
  await subject3.close();
}
