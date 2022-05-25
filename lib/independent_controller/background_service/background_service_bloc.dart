// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/user_account/user_account_cubit.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';
import 'package:meta/meta.dart';

part 'background_service_event.dart';
part 'background_service_state.dart';

class BackgroundServiceBloc
    extends Bloc<BackgroundServiceEvent, BackgroundServiceState> {
  BackgroundServiceBloc(
      {required this.userCubit, required this.connectionCubit})
      : super(BackgroundServiceInitial()) {
    on(mapEvent);
    connectionMonitor = connectionCubit.stream.listen((event) {
      if (event is InternetConnected) {
        add(const BackgroundServiceConnectionEstablished());
      } else {
        add(const BackgroundServiceConnectionInterruptsProcess());
      }
    });
    userMonitor = userCubit.stream.listen((userState) {
      if (userState is UserAccountAttached) {
        add(const BackgroundServiceUserLoggedIn());
      } else {
        add(const BackgroundServiceUserLoggedOut());
      }
    });
  }

  final UserAccountCubit userCubit;
  final ConnectivityCubit connectionCubit;
  late StreamSubscription userMonitor;
  late StreamSubscription connectionMonitor;
  final APIUserService apiUser = APIUserService();

  Future<void> mapEvent(BackgroundServiceEvent event,
      Emitter<BackgroundServiceState> emit) async {
    if (event is BackgroundServiceInitiateServiceStart) {
      initializeService();
    } else if (event is BackgroundServiceStartProcess) {
      backgroundProcess();
    } else if (event is BackgroundServiceConnectionInterruptsProcess) {
      // emit(BackgroundServiceStoppedState());
    } else if (event is BackgroundServiceUserLoggedOut) {
      emit(BackgroundServiceStoppedState());
    } else if (event is BackgroundServiceConnectionEstablished ||
        event is BackgroundServiceUserLoggedIn) {
      add(const BackgroundServiceInitiateServiceStart());
    } else if (event is BackgroundServiceStatusChange) {
      if (event.isReady) {
        add(const BackgroundServiceStartProcess());
      } else {
        add(const BackgroundServiceStopProcess());
      }
    }
  }

  void initializeService() {
    if (state is BackgroundServiceRunningState) {
      return;
    }
    if (userCubit.state is UserAccountAttached &&
        connectionCubit.state is InternetConnected) {
      add(const BackgroundServiceStatusChange(isReady: true));
    } else {
      add(const BackgroundServiceStatusChange(isReady: false));
    }
  }

  Future<void> backgroundProcess() async {
    if (state is BackgroundServiceRunningState) {
    } else {
      emit(BackgroundServiceRunningState());

      await Future.delayed(const Duration(seconds: 30));
      if ((connectionCubit.state is NoInternetConnections)) {
      } else {
        await apiUser.backgroundHit();
      }
      emit(BackgroundServiceIdleState());
      initializeService();
    }
  }

  @override
  Future<void> close() {
    userMonitor.cancel();
    connectionMonitor.cancel();
    return super.close();
  }
}
