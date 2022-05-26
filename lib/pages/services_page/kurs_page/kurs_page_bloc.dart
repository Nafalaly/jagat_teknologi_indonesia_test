// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:money_converter/Currency.dart' as money;
import 'package:money_converter/money_converter.dart' as money;

part 'kurs_page_event.dart';
part 'kurs_page_state.dart';

class KursPageBloc extends Bloc<KursPageEvent, KursPageState> {
  KursPageBloc(
      {required List<Currency> availableCurrencies,
      required List<OutletSub> availableOutletSub,
      required OutletSub currentOutletSub,
      required UserData current,
      required this.connection})
      : super(KursPageIdleState.setInitialData(
            availableCurrencies: availableCurrencies,
            availableOutletSub: availableOutletSub,
            currentOutletSub: currentOutletSub,
            connection: connection.state)) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(KursConnectionEstablished());
      } else {
        add(KursInteruptedByConnection());
      }
    });
    on(mapEvent);
  }
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(
      KursPageEvent event, Emitter<KursPageState> emit) async {
    if (event is KursSubOutletChangeEvent) {
      emit((state as KursPageIdleState).copyWith(outletSub: event.newOutlet));
    } else if (event is KursCurrencyChangeEvent) {
      emit((state as KursPageIdleState)
          .copyWith(currency: event.newCurrency, outputValue: 0));
    } else if (event is KursCurrencyToChangeEvent) {
      emit((state as KursPageIdleState)
          .copyWith(toCurrency: event.newCurrency, outputValue: 0));
    } else if (event is KursInputValueChangeEvent) {
      emit((state as KursPageIdleState)
          .copyWith(inputValue: event.newValue, outputValue: 0));
    } else if (event is KursOutputValueChangeEvent) {
      emit((state as KursPageIdleState).copyWith(
          outputValue: event.newValue, inputState: const KursFormInputIdle()));
    } else if (event is KursSubmitAttemptEvent) {
      int? errorCodes = (state as KursPageIdleState).validator();
      if (errorCodes != null) {
        switch (errorCodes) {
          case 501:
            add(KursBadInput(
                message: 'Silahkan pilih outlet', badInputCode: errorCodes));
            break;
          case 502:
            add(KursBadInput(
                message: 'Nominal tidak boleh kosong',
                badInputCode: errorCodes));
            break;
          case 503:
            add(KursBadInput(
                message: 'Silahkan pilih mata uang konversi',
                badInputCode: errorCodes));
            break;
          case 504:
            add(KursBadInput(
                message: 'Mata uang sama', badInputCode: errorCodes));
            break;
          default:
            add(KursBadInput(message: 'Bad Input State', badInputCode: 0));
            break;
        }
      } else {
        if ((state as KursPageIdleState).connectionStatus
            is InternetConnected) {
          emit((state as KursPageIdleState)
              .copyWith(inputState: KursFormSubmitting()));

          calculateKurs();
        } else {
          add(KursInteruptedByConnection());
        }
      }
    } else if (event is KursConnectionEstablished) {
      emit((state as KursPageIdleState)
          .copyWith(connectionStatus: const InternetConnected()));
    } else if (event is KursInteruptedByConnection) {
      emit((state as KursPageIdleState).copyWith(
          connectionStatus: const NoInternetConnections(),
          inputState: const KursFormInteruptedByConnection()));
    } else if (event is KursBadInput) {
      emit((state as KursPageIdleState).copyWith(
          inputState: KursFormBadInputState(
              message: event.message, badInputCode: event.badInputCode)));
    } else if (event is KursDismissFormState ||
        event is KursConnectionWarningDismiss) {
      emit((state as KursPageIdleState)
          .copyWith(inputState: const KursFormInputIdle()));
    } else if (event is KursAttemptSuccess) {
      emit(
          (state as KursPageIdleState).copyWith(inputState: KursFormSuccess()));
    } else if (event is KursAttemptFailed) {
      emit((state as KursPageIdleState)
          .copyWith(inputState: KursFormFailed(message: event.message)));
    }
  }

  Future<void> calculateKurs() async {
    var usdConvert = await money.MoneyConverter.convert(
        money.Currency(state.selectedCurrency!.currencyName,
            amount: state.inputValue),
        money.Currency(state.selectedToCurrency!.currencyName));
    add(KursOutputValueChangeEvent(newValue: usdConvert.toString()));
    return;
  }

  @override
  Future<void> close() {
    connectionMonitor.cancel();
    return super.close();
  }
}
