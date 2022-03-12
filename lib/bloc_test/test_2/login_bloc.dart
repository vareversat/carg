import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carg/bloc_test/test_2/login_event.dart';
import 'package:carg/bloc_test/test_2/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final StreamSubscription _loginSubscription;

  LoginBloc() : super(const LoginState.email()) {
    on<EmailLoginMethod>(_onEmailLogin);
    on<PhoneLoginMethod>(_onPhoneLogin);
    on<GoogleLoginMethod>(_onGoogleLogin);
  }

  void _onEmailLogin(LoginEvent event, Emitter<LoginState> emit) {
    emit(const LoginState.email());
  }

  void _onPhoneLogin(LoginEvent event, Emitter<LoginState> emit) {
    emit(const LoginState.phone());
  }

  void _onGoogleLogin(LoginEvent event, Emitter<LoginState> emit) {
    emit(const LoginState.google());
  }

  @override
  Future<void> close() {
    _loginSubscription.cancel();
    return super.close();
  }
}
