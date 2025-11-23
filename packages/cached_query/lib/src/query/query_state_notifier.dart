// ignore_for_file: cascade_invocations

import 'package:cached_query/src/query/controller_action.dart';
import 'package:cached_query/src/util/option.dart';

/// {@template Event}
/// A base class for events emitted by the [QueryStateNotifier].
/// {@endtemplate}
sealed class Event<A> {
  ///{@macro Event}
  Event(this.action);

  /// The action associated with this event.
  final A action;
}

/// {@template InitialEvent}
/// An event that represents the initial value emitted to new listeners.
/// This event is sent immediately upon subscription to provide the current
/// state of the stream.
///
/// It is only sent once per listener, right after they subscribe.
/// {@endtemplate}
class InitialEvent<A> extends Event<A> {
  ///{@macro InitialEvent}
  InitialEvent(super.action);
}

/// {@template DataEvent}
/// An event that represents a data update in the stream.
/// This event is emitted whenever new data is added to the stream.
/// {@endtemplate}
class DataEvent<A> extends Event<A> {
  ///{@macro DataEvent}
  DataEvent(super.action);
}

/// A callback function with no arguments and no return value.
typedef Listener<T> = void Function(T value);

/// {@template QueryStateNotifier}
/// A synchronous notifier that manages and notifies listeners about changes to a query controller's state.
/// {@endtemplate}
class QueryStateNotifier<T> {
  ///{@macro QueryStateNotifier}
  QueryStateNotifier([ControllerState<T>? initialState])
      : _state = initialState ??
            ControllerState(
              data: Option.none(),
              timeCreated: DateTime.now(),
            );
  ControllerState<T> _state;
  ControllerAction<T>? _lastAction;

  final List<Listener<Event<ControllerAction<T>>>> _listeners = [];

  /// The current value stored in this controller.
  ControllerState<T> get value {
    return _state;
  }

  /// Adds a new value to the stream and updates the stored value.
  void add(ControllerAction<T> action) {
    _lastAction = action;
    switch (action) {
      case Fetch<T>():
      case FetchError<T>():
      case StorageError<T>():
        break;
      case DataUpdated<T>(:final data, :final timeCreated):
        _state = ControllerState(
          data: Some(data),
          timeCreated: timeCreated,
        );
        break;
      case Success<T>(:final data, :final timeCreated):
        _state = ControllerState(
          data: data,
          timeCreated: timeCreated,
        );
        break;
    }
    _notifyListeners();
  }

  void _notifyListeners() {
    if (_lastAction == null) {
      return;
    }
    for (final listener in _listeners) {
      listener(DataEvent(_lastAction!));
    }
  }

  /// Adds a listener that will be called whenever an action is added.
  void addListener(
    Listener<Event<ControllerAction<T>>> listener,
  ) {
    _listeners.add(listener);
    if (_lastAction != null) {
      listener(
        InitialEvent(_lastAction!),
      );
    }
  }

  /// Removes a previously added listener.
  void removeListener(
    Listener<Event<ControllerAction<T>>> listener,
  ) {
    _listeners.remove(listener);
  }

  /// Closes the notifier and clears all listeners.
  void close() {
    _listeners.clear();
  }
}
