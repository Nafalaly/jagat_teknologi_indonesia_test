part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginAttempt extends LoginEvent {
  final String username;
  final String password;
  LoginAttempt({required this.username, required this.password});
}

class LoginFormUsernameChanged extends LoginEvent {
  final String username;
  LoginFormUsernameChanged({required this.username});
}

class LoginFormPasswordChanged extends LoginEvent {
  final String password;
  LoginFormPasswordChanged({required this.password});
}

class LoginPasswordFormVisibleChanged extends LoginEvent {
  final bool visibleStatus;
  LoginPasswordFormVisibleChanged({required this.visibleStatus});
}

class LoginAttemptSucessfully extends LoginEvent {}

class LoginConnectionWarningDismiss extends LoginEvent {}

class LoginInteruptedByConnection extends LoginEvent {}

class LoginConnectionEstablished extends LoginEvent {}

class LoginDismissBadInput extends LoginEvent {
  LoginDismissBadInput();
}

class LoginBadInput extends LoginEvent {
  final String message;
  LoginBadInput({required this.message});
}

class LoginFailed extends LoginEvent {
  final String message;
  LoginFailed({required this.message});
}
