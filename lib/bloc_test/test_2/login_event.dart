import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent(this.title, this.message);

  final String title;
  final String message;

  @override
  List<Object> get props => [];
}

// First Event : Select email login method
class EmailLoginMethod extends LoginEvent {
  const EmailLoginMethod() : super("email", "email_message");
}

// Second Event : Select phone login method
class PhoneLoginMethod extends LoginEvent {
  const PhoneLoginMethod() : super("phone", "phone_message");
}

// Third Event : Select Google login method
class GoogleLoginMethod extends LoginEvent {
  const GoogleLoginMethod() : super("google", "google_message");
}
