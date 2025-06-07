typedef VoidErrorCallback = void Function(Object error, StackTrace stackTrace);

typedef StateErrorCallback<State, Error> =
    State? Function(Error error, StackTrace stackTrace);
