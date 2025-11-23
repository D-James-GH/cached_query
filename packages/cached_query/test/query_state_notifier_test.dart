// ignore_for_file: cascade_invocations

import 'package:cached_query/cached_query.dart';
import 'package:cached_query/src/query/controller_action.dart';
import 'package:cached_query/src/query/query_state_notifier.dart';
import 'package:cached_query/src/util/option.dart';
import 'package:test/test.dart';

void main() {
  group('QueryStateNotifier', () {
    group('initialization', () {
      test('creates default state when no initial state provided', () {
        final notifier = QueryStateNotifier<int>();
        expect(notifier.value.data, isA<None<int>>());
      });

      test('uses provided initial state', () {
        final initialState = ControllerState<int>(
          data: Some(42),
          timeCreated: DateTime(2024),
        );
        final notifier = QueryStateNotifier<int>(initialState);
        expect(notifier.value.data, isA<Some<int>>());
        expect((notifier.value.data as Some<int>).value, equals(42));
        expect(notifier.value.timeCreated, equals(DateTime(2024)));
      });
    });

    group('state updates', () {
      test('Success action updates state with provided data', () {
        final notifier = QueryStateNotifier<int>();
        final timeCreated = DateTime(2024);
        notifier.add(
          Success<int>(data: Some(42), timeCreated: timeCreated),
        );

        expect(notifier.value.data, isA<Some<int>>());
        expect((notifier.value.data as Some<int>).value, equals(42));
        expect(notifier.value.timeCreated, equals(timeCreated));
      });

      test('Success action with None updates state', () {
        final notifier = QueryStateNotifier<int>();
        final timeCreated = DateTime(2024);
        notifier.add(
          Success<int>(data: const None<int>(), timeCreated: timeCreated),
        );

        expect(notifier.value.data, isA<None<int>>());
        expect(notifier.value.timeCreated, equals(timeCreated));
      });

      test('DataUpdated action updates state', () {
        final notifier = QueryStateNotifier<int>();
        final timeCreated = DateTime(2024);
        notifier.add(
          DataUpdated<int>(data: 99, timeCreated: timeCreated),
        );

        expect(notifier.value.data, isA<Some<int>>());
        expect((notifier.value.data as Some<int>).value, equals(99));
        expect(notifier.value.timeCreated, equals(timeCreated));
      });

      test('Fetch action does not update state', () {
        final notifier = QueryStateNotifier<int>();
        final initialState = notifier.value;

        notifier.add(
          Fetch<int>(
            fetchOptions: const FetchOptions(),
            isInitialFetch: false,
          ),
        );

        expect(notifier.value, equals(initialState));
      });

      test('FetchError action does not update state', () {
        final notifier = QueryStateNotifier<int>();
        final initialState = notifier.value;

        notifier.add(
          FetchError<int>(
            error: Exception('test error'),
            stackTrace: StackTrace.current,
          ),
        );

        expect(notifier.value, equals(initialState));
      });

      test('StorageError action does not update state', () {
        final notifier = QueryStateNotifier<int>();
        final initialState = notifier.value;

        notifier.add(
          StorageError<int>(
            error: Exception('storage error'),
            stackTrace: StackTrace.current,
          ),
        );

        expect(notifier.value, equals(initialState));
      });
    });

    group('listener notifications', () {
      test('new listener receives InitialEvent with last action', () {
        final notifier = QueryStateNotifier<int>();
        final action = Success<int>(
          data: Some(42),
          timeCreated: DateTime(2024),
        );
        notifier.add(action);

        Event<ControllerAction<int>>? receivedEvent;
        notifier.addListener((event) {
          receivedEvent = event;
        });

        expect(receivedEvent, isA<InitialEvent<ControllerAction<int>>>());
        expect(receivedEvent!.action, equals(action));
      });

      test('new listener receives no event when no action has been added', () {
        final notifier = QueryStateNotifier<int>();

        Event<ControllerAction<int>>? receivedEvent;
        notifier.addListener((event) {
          receivedEvent = event;
        });

        expect(receivedEvent, isNull);
      });

      test('listener receives DataEvent when action is added', () {
        final notifier = QueryStateNotifier<int>();
        Event<ControllerAction<int>>? receivedEvent;

        notifier.addListener((event) {
          receivedEvent = event;
        });

        final action = Success<int>(
          data: Some(42),
          timeCreated: DateTime(2024),
        );
        notifier.add(action);

        expect(receivedEvent, isA<DataEvent<ControllerAction<int>>>());
        expect(receivedEvent!.action, equals(action));
      });

      test('listener receives DataEvent for actions that do not update state',
          () {
        final notifier = QueryStateNotifier<int>();
        final events = <Event<ControllerAction<int>>>[];

        notifier.addListener(events.add);

        final fetchAction = Fetch<int>(
          fetchOptions: const FetchOptions(),
          isInitialFetch: false,
        );
        notifier.add(fetchAction);

        expect(events.length, equals(1));
        expect(events[0], isA<DataEvent<ControllerAction<int>>>());
        expect(events[0].action, equals(fetchAction));
      });

      test('multiple listeners all receive events', () {
        final notifier = QueryStateNotifier<int>();
        final listener1Events = <Event<ControllerAction<int>>>[];
        final listener2Events = <Event<ControllerAction<int>>>[];
        final listener3Events = <Event<ControllerAction<int>>>[];

        notifier.addListener(listener1Events.add);
        notifier.addListener(listener2Events.add);
        notifier.addListener(listener3Events.add);

        final action = Success<int>(
          data: Some(42),
          timeCreated: DateTime(2024),
        );
        notifier.add(action);

        expect(listener1Events.length, equals(1));
        expect(listener2Events.length, equals(1));
        expect(listener3Events.length, equals(1));

        expect(listener1Events[0], isA<DataEvent<ControllerAction<int>>>());
        expect(listener2Events[0], isA<DataEvent<ControllerAction<int>>>());
        expect(listener3Events[0], isA<DataEvent<ControllerAction<int>>>());
      });

      test('listener receives multiple events for multiple actions', () {
        final notifier = QueryStateNotifier<int>();
        final events = <Event<ControllerAction<int>>>[];

        notifier.addListener(events.add);

        final action1 = Fetch<int>(
          fetchOptions: const FetchOptions(),
          isInitialFetch: false,
        );
        final action2 = Success<int>(
          data: Some(42),
          timeCreated: DateTime(2024),
        );
        final action3 = DataUpdated<int>(
          data: 99,
          timeCreated: DateTime(2024, 1, 2),
        );

        notifier.add(action1);
        notifier.add(action2);
        notifier.add(action3);

        expect(events.length, equals(3));
        expect(events[0].action, equals(action1));
        expect(events[1].action, equals(action2));
        expect(events[2].action, equals(action3));
      });
    });

    group('removeListener', () {
      test('removed listener does not receive further events', () {
        final notifier = QueryStateNotifier<int>();
        final events = <Event<ControllerAction<int>>>[];

        void listener(Event<ControllerAction<int>> event) {
          events.add(event);
        }

        notifier.addListener(listener);
        notifier.add(
          Fetch<int>(
            fetchOptions: const FetchOptions(),
            isInitialFetch: false,
          ),
        );

        expect(events.length, equals(1));

        notifier.removeListener(listener);
        notifier.add(
          Fetch<int>(
            fetchOptions: const FetchOptions(),
            isInitialFetch: false,
          ),
        );

        expect(events.length, equals(1)); // No new event received
      });

      test('removing one listener does not affect others', () {
        final notifier = QueryStateNotifier<int>();
        final listener1Events = <Event<ControllerAction<int>>>[];
        final listener2Events = <Event<ControllerAction<int>>>[];

        void listener1(Event<ControllerAction<int>> event) {
          listener1Events.add(event);
        }

        void listener2(Event<ControllerAction<int>> event) {
          listener2Events.add(event);
        }

        notifier.addListener(listener1);
        notifier.addListener(listener2);

        notifier.removeListener(listener1);
        notifier.add(
          Fetch<int>(
            fetchOptions: const FetchOptions(),
            isInitialFetch: false,
          ),
        );

        expect(listener1Events.length, equals(0));
        expect(listener2Events.length, equals(1));
      });
    });

    group('close', () {
      test('clears all listeners', () {
        final notifier = QueryStateNotifier<int>();
        final listener1Events = <Event<ControllerAction<int>>>[];
        final listener2Events = <Event<ControllerAction<int>>>[];

        notifier.addListener(listener1Events.add);
        notifier.addListener(listener2Events.add);

        notifier.close();
        notifier.add(
          Fetch<int>(
            fetchOptions: const FetchOptions(),
            isInitialFetch: false,
          ),
        );

        expect(listener1Events.length, equals(0));
        expect(listener2Events.length, equals(0));
      });
    });

    group('event distinction', () {
      test('new listener receives InitialEvent, updates receive DataEvent', () {
        final notifier = QueryStateNotifier<int>();
        final events = <Event<ControllerAction<int>>>[];

        // Add first action
        notifier.add(
          Fetch<int>(
            fetchOptions: const FetchOptions(),
            isInitialFetch: false,
          ),
        );

        // Add listener - should receive InitialEvent
        notifier.addListener(events.add);

        expect(events.length, equals(1));
        expect(events[0], isA<InitialEvent<ControllerAction<int>>>());

        // Add another action - should receive DataEvent
        notifier.add(
          Success<int>(data: Some(42), timeCreated: DateTime(2024)),
        );

        expect(events.length, equals(2));
        expect(events[1], isA<DataEvent<ControllerAction<int>>>());
      });
    });
  });
}
