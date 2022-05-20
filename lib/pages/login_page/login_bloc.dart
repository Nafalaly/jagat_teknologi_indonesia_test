// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/user_account/user_account_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.connection, required this.accountCubit})
      : super(LoginIdleState()) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(LoginConnectionEstablished());
      } else {
        add(LoginInteruptedByConnection());
      }
    });
    on(mapEvent);
  }
  UserAccountCubit accountCubit;
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginAttempt) {
      if (!(state as LoginIdleState).usernameValidator()) {
        add(LoginBadInput(message: 'Username must not be empty'));
      } else if (!(state as LoginIdleState).passwordValidator()) {
        add(LoginBadInput(message: 'Password must not be empty'));
      } else {
        if ((state as LoginIdleState).connectionStatus is InternetConnected) {
          login();
        } else {
          add(LoginInteruptedByConnection());
        }
      }
    } else if (event is LoginConnectionEstablished) {
      emit((state as LoginIdleState)
          .copyWith(connectionStatus: const InternetConnected()));
    } else if (event is LoginInteruptedByConnection) {
      emit((state as LoginIdleState).copyWith(
          connectionStatus: const NoInternetConnections(),
          inputState: const LoginFormInteruptedByConnection()));
    } else if (event is LoginBadInput) {
      emit((state as LoginIdleState).copyWith(
          inputState: LoginFormBadInputState(message: event.message)));
    } else if (event is LoginDismissBadInput ||
        event is LoginConnectionWarningDismiss) {
      emit((state as LoginIdleState)
          .copyWith(inputState: const LoginFormInputIdle()));
    } else if (event is LoginFormUsernameChanged) {
      emit((state as LoginIdleState).copyWith(username: event.username));
    } else if (event is LoginFormPasswordChanged) {
      emit((state as LoginIdleState).copyWith(password: event.password));
    } else if (event is LoginPasswordFormVisibleChanged) {
      emit((state as LoginIdleState)
          .copyWith(passwordVisible: event.visibleStatus));
    } else if (event is LoginAttemptSucessfully) {
      emit(LoginSucessfullyState());
    } else if (event is LoginFailed) {
      emit((state as LoginIdleState)
          .copyWith(inputState: LoginFormAccountNotFound()));
    }
  }

  APIUserService apiUserService = APIUserService();

  Future<void> login() async {
    ResponseParser result = await apiUserService.loginUser(
        user: (state as LoginIdleState).username,
        pass: (state as LoginIdleState).password);
    if (result.getStatus == ResponseStatus.success) {
      await accountCubit.setAccount(
          newAccount: UserData.fromJson(data: result.getData!));
      add(LoginAttemptSucessfully());
    } else {
      if (result.getStatusCode == 1002) {
        add(LoginFailed(message: 'Username atau password salah'));
      } else {
        add(LoginFailed(message: 'Something went wrong'));
      }
    }
    return;
  }

  @override
  Future<void> close() {
    connectionMonitor.cancel();
    return super.close();
  }
}
