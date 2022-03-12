import 'package:equatable/equatable.dart';

enum LoginMethod { email, phone, google }

class LoginState extends Equatable {
  final LoginMethod loginMethod;

  const LoginState._({
    required this.loginMethod,
  });

  const LoginState.email() : this._(loginMethod: LoginMethod.email);
  const LoginState.phone() : this._(loginMethod: LoginMethod.phone);
  const LoginState.google() : this._(loginMethod: LoginMethod.google);

  @override
  List<Object> get props => [loginMethod];
}
