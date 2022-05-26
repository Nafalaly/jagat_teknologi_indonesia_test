// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';

part 'mutasi_page_event.dart';
part 'mutasi_page_state.dart';

class MutasiPageBloc extends Bloc<MutasiPageEvent, MutasiPageState> {
  MutasiPageBloc(
      {required List<Currency> availableCurrencies,
      required List<OutletSub> availableOutletSub,
      required OutletSub currentOutletSub,
      required UserData current,
      required this.connection})
      : super(MutasiPageIdleState.setInitialData(
            currentUser: current,
            availableCurrencies: availableCurrencies,
            availableOutletSub: availableOutletSub,
            currentOutletSub: currentOutletSub,
            connection: connection.state)) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(MutasiConnectionEstablished());
      } else {
        add(MutasiInteruptedByConnection());
      }
    });
    on(mapEvent);
  }
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(
      MutasiPageEvent event, Emitter<MutasiPageState> emit) async {
    if (event is MutasiSubOutletChangeEvent) {
      emit((state as MutasiPageIdleState).copyWith(outletSub: event.newOutlet));
    } else if (event is MutasiCurrencyChangeEvent) {
      emit((state as MutasiPageIdleState)
          .copyWith(currency: event.newCurrency, outputValue: 0));
    } else if (event is MutasiCurrencyToChangeEvent) {
      emit((state as MutasiPageIdleState)
          .copyWith(toCurrency: event.newCurrency, outputValue: 0));
    } else if (event is MutasiInputValueChangeEvent) {
      emit((state as MutasiPageIdleState)
          .copyWith(inputValue: event.newValue, outputValue: 0));
    } else if (event is MutasiOutputValueChangeEvent) {
      emit((state as MutasiPageIdleState).copyWith(
          outputValue: event.newValue,
          inputState: const MutasiFormInputIdle()));
    } else if (event is MutasiSubmitAttemptEvent) {
      if ((state as MutasiPageIdleState).connectionStatus
          is InternetConnected) {
        emit((state as MutasiPageIdleState)
            .copyWith(inputState: MutasiFormSubmitting()));
        uploadMutasi();
      } else {
        add(MutasiInteruptedByConnection());
      }
    } else if (event is MutasiConnectionEstablished) {
      emit((state as MutasiPageIdleState)
          .copyWith(connectionStatus: const InternetConnected()));
    } else if (event is MutasiInteruptedByConnection) {
      emit((state as MutasiPageIdleState).copyWith(
          connectionStatus: const NoInternetConnections(),
          inputState: const MutasiFormInteruptedByConnection()));
    } else if (event is MutasiBadInput) {
      emit((state as MutasiPageIdleState).copyWith(
          inputState: MutasiFormBadInputState(
              message: event.message, badInputCode: event.badInputCode)));
    } else if (event is MutasiDismissFormState ||
        event is MutasiConnectionWarningDismiss) {
      emit((state as MutasiPageIdleState)
          .copyWith(inputState: const MutasiFormInputIdle()));
    } else if (event is MutasiAttemptSuccess) {
      emit((state as MutasiPageIdleState)
          .copyWith(inputState: MutasiFormSuccess()));
    } else if (event is MutasiAttemptFailed) {
      emit((state as MutasiPageIdleState)
          .copyWith(inputState: MutasiFormFailed(message: event.message)));
    } else if (event is MutasiOpenFilterPanelEvent) {
      emit((state as MutasiPageIdleState)
          .copyWith(statePanel: const PanelOpening()));
      emit((state as MutasiPageIdleState)
          .copyWith(statePanel: const PanelOpened()));
    } else if (event is MutasiCloseFilterPanelEvent) {
      emit((state as MutasiPageIdleState)
          .copyWith(statePanel: const PanelClosed()));
    } else if (event is MutasiStartDateChangeEvent) {
      emit((state as MutasiPageIdleState).copyWith(startDate: event.newDate));
    } else if (event is MutasiToDateChangeEvent) {
      emit((state as MutasiPageIdleState).copyWith(toDate: event.newDate));
    } else if (event is MutasiUseFilterSwitch) {
      emit((state as MutasiPageIdleState)
          .copyWith(useFilter: event.switchState));
    }
  }

  APITransaction apiTransaction = APITransaction();

  Future<void> uploadMutasi() async {
    ResponseParser result = await apiTransaction.getTransaksi(
        state: (state as MutasiPageIdleState));
    if (result.getStatus == ResponseStatus.success) {
      add(MutasiAttemptSuccess());
    } else {
      add(MutasiAttemptFailed(message: 'Something went wrong'));
    }
    return;
  }

  @override
  Future<void> close() {
    connectionMonitor.cancel();
    return super.close();
  }
}
