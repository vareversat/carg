import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carg/bloc_test/test_1/app_event.dart';
import 'package:carg/bloc_test/test_1/app_state.dart';
import 'package:carg/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _userSubscription;


  AppBloc({required AuthService authService})
      : _authService = authService,
        super(
          authService.connectedUser != null
              ? AppState.authenticated(authService.connectedUser)
              : const AppState.unauthenticated(),
        ) {

    on<AppUserChanged>(_onUserChanged);
    _userSubscription = _authService.user.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(event.user != null
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
