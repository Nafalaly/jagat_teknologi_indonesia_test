part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

class LoginSucessfullyState extends LoginState {}

// ignore: must_be_immutable
class LoginIdleState extends LoginState {
  String username;
  String password;
  bool usernameValidator() => username != '';
  bool passwordValidator() => password != '';
  bool passwordVisible;
  LoginInputState inputState;
  ConnectivityState connectionStatus;

  LoginIdleState({
    this.username = '',
    this.password = '',
    this.connectionStatus = const InternetInitial(),
    this.inputState = const LoginFormInputIdle(),
    this.passwordVisible = true,
  });

  LoginIdleState copyWith(
      {String? username,
      String? password,
      bool? passwordVisible,
      ConnectivityState? connectionStatus,
      LoginInputState? inputState}) {
    return LoginIdleState(
      username: username ?? this.username,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      inputState: inputState ?? this.inputState,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
}

abstract class LoginInputState {
  const LoginInputState();
}

class LoginFormInteruptedByConnection extends LoginInputState {
  const LoginFormInteruptedByConnection();
}

class LoginFormAccountNotFound extends LoginInputState {}

class LoginFormBadInputState extends LoginInputState {
  final String message;
  LoginFormBadInputState({required this.message});
}

class LoginFormInputIdle extends LoginInputState {
  const LoginFormInputIdle();
}
