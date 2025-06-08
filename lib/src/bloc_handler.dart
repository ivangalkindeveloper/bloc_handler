import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_handler/bloc_handler.dart';

mixin BlocHandlerMixin<
  Event,
  State,
  ApiError extends Object,
  ConnectionError extends Object
>
    on Bloc<Event, State> {
  State? get defaultApiErrorState => null;
  State? get defaultConnectionErrorState => null;
  State? get defaultUnknownErrorState => null;

  Future<void> handle(
    Emitter<State> emit,
    FutureOr<void> Function() execute, {
    bool fallback = false,
    VoidErrorCallback? onError,
    StateErrorCallback<State, ApiError>? getApiErrorState,
    StateErrorCallback<State, ConnectionError>? getConnectionErrorState,
    StateErrorCallback<State, Object>? getUnknownErrorState,
    StateErrorCallback<State, Object>? getFallbackState,
    void Function()? onFinally,
  }) async {
    State currentState = state;
    State? errorState;

    try {
      try {
        await execute();
      } catch (error, stackTrace) {
        onError?.call(error, stackTrace);
        if (fallback) {
          currentState =
              getFallbackState?.call(error, stackTrace) ?? currentState;
        }
        rethrow;
      }
    } on ApiError catch (error, stackTrace) {
      errorState =
          getApiErrorState?.call(error, stackTrace) ?? defaultApiErrorState;
      super.onError(error, stackTrace);
    } on ConnectionError catch (error, stackTrace) {
      errorState =
          getConnectionErrorState?.call(error, stackTrace) ??
          defaultConnectionErrorState;
      super.onError(error, stackTrace);
    } on Object catch (error, stackTrace) {
      errorState =
          getUnknownErrorState?.call(error, stackTrace) ??
          defaultUnknownErrorState;
      super.onError(error, stackTrace);
    } finally {
      if (errorState != null) {
        emit(errorState);
      }
      if (fallback) {
        emit(currentState);
      }
      onFinally?.call();
    }
  }
}
