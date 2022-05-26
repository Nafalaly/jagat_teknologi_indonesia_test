// ignore_for_file: must_be_immutable

part of 'kurs_page_bloc.dart';

@immutable
abstract class KursPageState {
  late List<Currency> availableCurrencies = [];
  late List<Currency> availableToCurrencies = [];
  late List<OutletSub> availableOutletSub = [];
  late ConnectivityState connectionStatus = const InternetInitial();
  late Currency? selectedCurrency;
  late Currency? selectedToCurrency;
  late OutletSub? selectedOutletSub;
  late double inputValue = 0;
  late double outputValue = 0;
  late KursInputState inputState = const KursFormInputIdle();
}

class KursPageInitial extends KursPageState {}

class KursPageErrorState extends KursPageState {
  final String errorMessage;
  KursPageErrorState({required this.errorMessage});
}

class KursPageIdleState extends KursPageState {
  int? validator() {
    if (selectedOutletSub!.id == null) {
      return 501;
    }
    if (inputValue == 0) {
      return 502;
    }
    if (selectedToCurrency!.id == null) {
      return 503;
    }

    if (selectedToCurrency!.id == selectedCurrency!.id) {
      return 504;
    }

    return null;
  }

  KursPageIdleState.setInitialData({
    required List<Currency> availableCurrencies,
    required List<OutletSub> availableOutletSub,
    required OutletSub currentOutletSub,
    required ConnectivityState connection,
  }) {
    super.connectionStatus = connection;
    super.availableCurrencies = availableCurrencies;
    super.selectedToCurrency = Currency.dummy();
    super.availableToCurrencies = List.from(availableCurrencies);
    super.availableToCurrencies.add(super.selectedToCurrency!);
    super.availableOutletSub = availableOutletSub;
    selectedCurrency = super.availableCurrencies[0];
    selectedOutletSub = currentOutletSub;
  }

  KursPageIdleState({
    Currency? currency,
    Currency? toCurrency,
    OutletSub? outletSub,
    List<Currency>? availableCurrencies,
    List<Currency>? availableToCurrencies,
    List<OutletSub>? availableOutletSub,
    double inputValue = 0,
    double outputValue = 0,
    ConnectivityState? connectionStatus,
    KursInputState inputState = const KursFormInputIdle(),
  }) {
    super.inputState = inputState;
    super.inputValue = inputValue;
    super.outputValue = outputValue;

    if (connectionStatus != null) {
      super.connectionStatus = connectionStatus;
    }
    if (availableOutletSub != null) {
      this.availableOutletSub = availableOutletSub;
    }
    if (availableCurrencies != null) {
      this.availableCurrencies = availableCurrencies;
    }
    if (availableToCurrencies != null) {
      this.availableToCurrencies = availableToCurrencies;
    }
    if (currency != null) {
      selectedCurrency = currency;
    }
    if (toCurrency != null) {
      selectedToCurrency = toCurrency;
    }

    if (outletSub != null) {
      selectedOutletSub = outletSub;
    }
  }

  KursPageIdleState copyWith({
    Currency? currency,
    Currency? toCurrency,
    double? inputValue,
    double? outputValue,
    List<Currency>? availableCurrencies,
    List<Currency>? availableToCurrencies,
    List<OutletSub>? availableOutletSub,
    OutletSub? outletSub,
    ConnectivityState? connectionStatus,
    KursInputState? inputState,
  }) {
    return KursPageIdleState(
      availableToCurrencies:
          availableToCurrencies ?? this.availableToCurrencies,
      outputValue: outputValue ?? this.outputValue,
      toCurrency: toCurrency ?? selectedToCurrency,
      currency: currency ?? selectedCurrency,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      availableOutletSub: availableOutletSub ?? this.availableOutletSub,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      outletSub: outletSub ?? selectedOutletSub,
      inputState: inputState ?? this.inputState,
      inputValue: inputValue ?? this.inputValue,
    );
  }
}

abstract class KursInputState {
  const KursInputState();
}

class KursFormSubmitting extends KursInputState {}

class KursFormSuccess extends KursInputState {}

class KursFormFailed extends KursInputState {
  final String message;
  KursFormFailed({required this.message});
}

class KursFormInteruptedByConnection extends KursInputState {
  const KursFormInteruptedByConnection();
}

class KursFormBadInputState extends KursInputState {
  final String message;
  final int badInputCode;
  KursFormBadInputState({required this.message, required this.badInputCode});
}

class KursFormInputIdle extends KursInputState {
  const KursFormInputIdle();
}
