import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

// First Event : Logout
class AppLogoutRequested extends AppEvent {}

// Second Event : User changed
class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User? user;
}