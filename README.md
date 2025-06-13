# Handler
Handler function for BLoC.\
Has an extended API closures that are triggered by successful and unsuccessful processing of the main closure.

# Usage
1) Prepare states, that contains ApiError, ConnectionError and UnknownError states:
```dart
sealed class State {
  const State();
}

final class LoadingState extends State {
  const LoadingState();
}

final class SuccessState extends State {
  const SuccessState({required this.profile});

  final Profile profile;
}

final class ApiErrorState extends State {
  const ApiErrorState();
}

final class ConnectionErrorState extends State {
  const ConnectionErrorState();
}

final class UnknownErrorState extends State {
  const UnknownErrorState();
}
```
2) Prepare BLoC and put handle method inside methods:
```dart
class ProfileBloc extends Bloc<Event, State>
    with BlocHandlerMixin<Event, State, ApiErrorState, ConnectionErrorState> {
  ProfileBloc({required Repository repository})
    : _repository = repository,
      super(const LoadingState()) {
    on<Event>(
      (event, emit) => switch (event) {
        SomeEvent() => _getProfile(event, emit),
      },
    );
  }

  final Repository _repository;

  @override
  State get defaultApiErrorState => const ApiErrorState();
  @override
  State get defaultConnectionErrorState => const ConnectionErrorState();
  @override
  State get defaultUnknownErrorState => const UnknownErrorState();

  Future<void> _getProfile(Event event, Emitter<State> emit) =>
      handle(emit, () async {
        final profile = await _repository.getProfile();
        emit(SuccessState(profile: profile));
      });
}
```

# API
```fallback``` - flag that determines whether to emit to the initial state;
```onError``` - callback triggered for any error;
```getApiErrorState``` - closure for ApiError, in case a different state is needed, different from the default state;
```getConnectionErrorState``` - closure for ConnectionError, in case a different state is needed, different from the default state;
```getUnknownErrorState``` - closure for unkwnonwn error, in case a different state is needed, different from the default state;
```getFallbackState``` - closure for fallback state, in case a different state is needed, different from the initial state;
```onFinally``` - callback triggered in the finally section.

# Additional information
For more details see example project.\
And feel free to open an issue if you find any bugs or errors or suggestions.