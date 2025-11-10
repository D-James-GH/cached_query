// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:cached_query/src/util/option.dart';

/// An event that can be emitted by the [StateStreamController].
sealed class Event<T> {
  /// The value of the event.
  final T value;
  Event(this.value);
}

/// {@template InitialEvent}
/// An event that represents the initial value emitted to new listeners.
/// {@endtemplate}
class InitialEvent<T> extends Event<T> {
  /// {@macro InitialEvent}
  InitialEvent(super.value);
}

/// {@template DataEvent}
/// An event that represents a regular data value emitted by the stream.
/// {@endtemplate}
class DataEvent<T> extends Event<T> {
  /// {@macro DataEvent}
  DataEvent(super.value);
}

/// {@template StateStreamController}
/// A [StreamController] that stores the latest value and emits it to new
/// listeners immediately upon subscription, similar to a BehaviorSubject.
///
/// This controller maintains the current state and ensures that new listeners
/// receive the most recent value as soon as they subscribe.
/// {@endtemplate}
class StateStreamController<T> {
  ///{@macro StateStreamController}
  StateStreamController([T? initialValue])
      : _value = initialValue == null ? Option.none() : Some(initialValue);
  Option<T> _value = None<T>();
  final _controller = StreamController<Event<T>>.broadcast(sync: true);

  /// The current value stored in this controller.
  T get value {
    if (_value case Some(:final value)) {
      return value;
    } else {
      throw StateError('No value present');
    }
  }

  /// The stream of values emitted by this controller.
  ///
  /// Each new listener will receive the current value immediately,
  /// followed by all subsequent values.
  Stream<Event<T>> get stream {
    if (_value.isSome) {
      return _controller.stream.withInitial(InitialEvent(value));
    }
    return _controller.stream;
  }

  /// Whether the controller is closed.
  bool get isClosed => _controller.isClosed;

  /// Adds a new value to the stream and updates the stored value.
  void add(T value) {
    _value = Some(value);
    _controller.add(DataEvent(value));
  }

  /// Adds an error to the stream.
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  /// Closes the stream controller.
  Future<void> close() => _controller.close();
}

/// Extends the Stream class with the ability to emit an initial value.
extension WithInitialExtension<T> on Stream<T> {
  /// Returns a Stream that emits the initial value first,
  /// then emits all items from the current Stream.
  ///
  /// ### Example
  ///
  ///     Stream.fromIterable([2, 3])
  ///         .withInitial(1)
  ///         .listen(print); // prints 1, 2, 3
  Stream<T> withInitial(T initialValue) {
    final controller = StreamController<T>(sync: true);
    StreamSubscription<T>? subscription;

    controller.onListen = () {
      // Emit initial value first
      controller.add(initialValue);

      // Then subscribe to the stream
      subscription = listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
    };
    controller.onPause = () => subscription?.pause();
    controller.onResume = () => subscription?.resume();
    controller.onCancel = () => subscription?.cancel();

    return controller.stream;
  }
}
