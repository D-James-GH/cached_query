// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:cached_query/src/util/state_stream_controller.dart';
import 'package:test/test.dart';

void main() {
  group('StateStreamController', () {
    test('should store initial value', () {
      final controller = StateStreamController<int>(42);
      expect(controller.value, 42);
    });

    test('should emit initial event to new listener', () async {
      final controller = StateStreamController<String>('initial');
      final events = <Event<String>>[];

      final subscription = controller.stream.listen(events.add);

      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      expect(events.first, isA<InitialEvent<String>>());
      expect((events.first as InitialEvent<String>).value, 'initial');

      await subscription.cancel();
    });

    test('should update value when adding new data', () {
      final controller = StateStreamController<int>(0)..add(10);
      expect(controller.value, 10);
    });

    test('should emit DataEvent when adding new value', () async {
      final controller = StateStreamController<int>(0);
      final events = <Event<int>>[];

      final subscription = controller.stream.listen(events.add);
      await Future<void>.delayed(Duration.zero);

      controller.add(5);
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 2);
      expect(events[0], isA<InitialEvent<int>>());
      expect(events[1], isA<DataEvent<int>>());
      expect((events[1] as DataEvent<int>).value, 5);

      await subscription.cancel();
    });

    test('should emit multiple values in sequence', () async {
      final controller = StateStreamController<int>(0);
      final events = <Event<int>>[];

      final subscription = controller.stream.listen(events.add);
      await Future<void>.delayed(Duration.zero);

      controller.add(1);
      controller.add(2);
      controller.add(3);
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 4);
      expect((events[0] as InitialEvent<int>).value, 0);
      expect((events[1] as DataEvent<int>).value, 1);
      expect((events[2] as DataEvent<int>).value, 2);
      expect((events[3] as DataEvent<int>).value, 3);

      await subscription.cancel();
    });

    test('should emit current value to late subscriber', () async {
      final controller = StateStreamController<String>('first');
      controller.add('second');
      controller.add('third');

      final events = <Event<String>>[];
      final subscription = controller.stream.listen(events.add);
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      expect(events.first, isA<InitialEvent<String>>());
      expect((events.first as InitialEvent<String>).value, 'third');

      await subscription.cancel();
    });

    test('should emit errors to stream', () async {
      final controller = StateStreamController<int>(0);
      final errors = <Object>[];

      final subscription = controller.stream.listen(
        (_) {},
        onError: errors.add,
      );

      final testError = Exception('test error');
      controller.addError(testError);
      await Future<void>.delayed(Duration.zero);

      expect(errors.length, 1);
      expect(errors.first, testError);

      await subscription.cancel();
    });

    test('should emit errors with stack trace', () async {
      final controller = StateStreamController<int>(0);
      final errors = <Object>[];
      final stackTraces = <StackTrace>[];

      final subscription = controller.stream.listen(
        (_) {},
        onError: (Object error, StackTrace stackTrace) {
          errors.add(error);
          stackTraces.add(stackTrace);
        },
      );

      final testError = Exception('test error');
      final testStackTrace = StackTrace.current;
      controller.addError(testError, testStackTrace);
      await Future<void>.delayed(Duration.zero);

      expect(errors.length, 1);
      expect(stackTraces.length, 1);
      expect(errors.first, testError);
      expect(stackTraces.first, testStackTrace);

      await subscription.cancel();
    });

    test('should close controller and stream', () async {
      final controller = StateStreamController<int>(0);
      expect(controller.isClosed, false);

      await controller.close();

      expect(controller.isClosed, true);
    });

    test('should complete stream when closed', () async {
      final controller = StateStreamController<int>(0);
      var streamCompleted = false;

      final subscription = controller.stream.listen(
        (_) {},
        onDone: () => streamCompleted = true,
      );

      await controller.close();
      await Future<void>.delayed(Duration.zero);

      expect(streamCompleted, true);
      await subscription.cancel();
    });

    test('should support multiple listeners', () async {
      final controller = StateStreamController<int>(100);
      final events1 = <Event<int>>[];
      final events2 = <Event<int>>[];

      final sub1 = controller.stream.listen(events1.add);
      final sub2 = controller.stream.listen(events2.add);
      await Future<void>.delayed(Duration.zero);

      controller.add(200);
      await Future<void>.delayed(Duration.zero);

      expect(events1.length, 2);
      expect(events2.length, 2);
      expect((events1[0] as InitialEvent<int>).value, 100);
      expect((events2[0] as InitialEvent<int>).value, 100);
      expect((events1[1] as DataEvent<int>).value, 200);
      expect((events2[1] as DataEvent<int>).value, 200);

      await sub1.cancel();
      await sub2.cancel();
    });

    test('should handle complex types', () async {
      final controller = StateStreamController<Map<String, dynamic>>({
        'key': 'value',
      });
      final events = <Event<Map<String, dynamic>>>[];

      final subscription = controller.stream.listen(events.add);
      await Future<void>.delayed(Duration.zero);

      final newValue = {'key': 'updated', 'count': 42};
      controller.add(newValue);
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 2);
      expect((events[1] as DataEvent<Map<String, dynamic>>).value, newValue);
      expect(controller.value, newValue);

      await subscription.cancel();
    });

    test('should handle null values', () async {
      final controller = StateStreamController<String?>()..add(null);
      final events = <Event<String?>>[];

      final subscription = controller.stream.listen(events.add);
      await Future<void>.delayed(Duration.zero);

      expect(controller.value, null);
      expect((events[0] as InitialEvent<String?>).value, null);

      controller.add('not null');
      controller.add(null);
      await Future<void>.delayed(Duration.zero);

      expect(controller.value, null);
      expect(events.length, 3);

      await subscription.cancel();
    });
  });

  group('WithInitialExtension', () {
    test('should emit initial value before stream values', () async {
      final values = <int>[];
      final stream = Stream.fromIterable([2, 3]).withInitial(1);

      await stream.forEach(values.add);

      expect(values, [1, 2, 3]);
    });

    test('should work with empty stream', () async {
      final values = <int>[];
      final stream = Stream<int>.fromIterable([]).withInitial(42);

      await stream.forEach(values.add);

      expect(values, [42]);
    });

    test('should emit initial value immediately on listen', () async {
      final values = <String>[];
      final controller = StreamController<String>();
      final stream = controller.stream.withInitial('initial');

      final subscription = stream.listen(values.add);
      await Future<void>.delayed(Duration.zero);

      expect(values, ['initial']);

      controller.add('second');
      await Future<void>.delayed(Duration.zero);

      expect(values, ['initial', 'second']);

      await subscription.cancel();
      await controller.close();
    });

    test('should propagate errors from original stream', () async {
      final errors = <Object>[];
      final controller = StreamController<int>();
      final stream = controller.stream.withInitial(0);

      final subscription = stream.listen(
        (_) {},
        onError: errors.add,
      );

      final testError = Exception('error');
      controller.addError(testError);
      await Future<void>.delayed(Duration.zero);

      expect(errors, [testError]);

      await subscription.cancel();
      await controller.close();
    });

    test('should complete when original stream completes', () async {
      var completed = false;
      final controller = StreamController<int>();
      final stream = controller.stream.withInitial(1);

      final subscription = stream.listen(
        (_) {},
        onDone: () => completed = true,
      );

      await controller.close();
      await Future<void>.delayed(Duration.zero);

      expect(completed, true);
      await subscription.cancel();
    });

    test('should support pause and resume', () async {
      final values = <int>[];
      final controller = StreamController<int>();
      final stream = controller.stream.withInitial(0);

      final subscription = stream.listen(values.add);
      await Future<void>.delayed(Duration.zero);

      subscription.pause();
      controller.add(1);
      controller.add(2);
      await Future<void>.delayed(Duration.zero);

      expect(values, [0]);

      subscription.resume();
      await Future<void>.delayed(Duration.zero);

      expect(values, [0, 1, 2]);

      await subscription.cancel();
      await controller.close();
    });

    test('should support cancellation', () async {
      final values = <int>[];
      final controller = StreamController<int>();
      final stream = controller.stream.withInitial(0);

      final subscription = stream.listen(values.add);
      await Future<void>.delayed(Duration.zero);

      await subscription.cancel();

      controller.add(1);
      await Future<void>.delayed(Duration.zero);

      expect(values, [0]);

      await controller.close();
    });

    test('should handle multiple initial values with chaining', () async {
      final values = <int>[];
      final stream =
          Stream.fromIterable([3, 4]).withInitial(2).map((v) => v * 2);

      await stream.forEach(values.add);

      expect(values, [4, 6, 8]);
    });
  });
}
