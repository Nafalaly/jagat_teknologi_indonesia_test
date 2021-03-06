// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';

part 'background_service_event.dart';
part 'background_service_state.dart';

class BackgroundServiceBloc
    extends Bloc<BackgroundServiceEvent, BackgroundServiceState> {
  BackgroundServiceBloc({required this.connectionCubit})
      : super(BackgroundServiceInitial()) {
    on(mapEvent);
    connectionMonitor = connectionCubit.stream.listen((event) {
      if (event is InternetConnected) {
        add(const BackgroundServiceConnectionEstablished());
      } else {
        add(const BackgroundServiceConnectionInterruptsProcess());
      }
    });
  }

  final ConnectivityCubit connectionCubit;

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
    if (connectionCubit.state is InternetConnected) {
      add(const BackgroundServiceStatusChange(isReady: true));
    } else {
      add(const BackgroundServiceStatusChange(isReady: false));
    }
  }

  Future<void> backgroundProcess() async {
    if (state is BackgroundServiceRunningState) {
    } else {
      emit(BackgroundServiceRunningState());
      if (kDebugMode) {
        print('Background waiting..');
      }
      await Future.delayed(const Duration(seconds: 30));
      if ((connectionCubit.state is NoInternetConnections)) {
      } else {
        await apiUser.backgroundHit();
        if (kDebugMode) {
          print('Background Sent at${DateTime.now()}');
        }
      }
      emit(BackgroundServiceIdleState());
      initializeService();
    }
  }

  @override
  Future<void> close() {
    connectionMonitor.cancel();
    return super.close();
  }
}
