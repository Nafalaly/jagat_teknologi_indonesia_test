// ignore_for_file: must_be_immutable

part of 'mutasi_page_bloc.dart';

@immutable
abstract class MutasiPageState {
  bool useFilter = false;
  List<Currency> availableCurrencies = [];
  List<Currency> availableToCurrencies = [];
  List<OutletSub> availableOutletSub = [];
  UserData currentUser = UserData();
  ConnectivityState connectionStatus = const InternetInitial();
  Currency? selectedCurrency;
  Currency? selectedToCurrency;
  OutletSub? selectedOutletSub;
  double inputValue = 0;
  double outputValue = 0;
  late DateTime startDate;
  late DateTime toDate;
  FilterPanelState filterPanelState = const PanelClosed();
  MutasiInputState inputState = const MutasiFormInputIdle();
}

class MutasiPageInitial extends MutasiPageState {}

class MutasiPageErrorState extends MutasiPageState {
  final String errorMessage;
  MutasiPageErrorState({required this.errorMessage});
}

class MutasiPageIdleState extends MutasiPageState {
  MutasiPageIdleState.setInitialData({
    required List<Currency> availableCurrencies,
    required List<OutletSub> availableOutletSub,
    required OutletSub currentOutletSub,
    required UserData currentUser,
    required ConnectivityState connection,
  }) {
    super.currentUser = currentUser;
    super.filterPanelState = const PanelClosed();
    DateTime now = DateTime.now();
    super.startDate = DateTime(now.year, now.month, 1);
    super.toDate = DateTime(now.year, now.month + 1, 0);
    super.connectionStatus = connection;
    super.availableCurrencies = availableCurrencies;
    super.selectedToCurrency = Currency.dummy();
    super.availableToCurrencies = List.from(availableCurrencies);
    super.availableToCurrencies.add(super.selectedToCurrency!);
    super.availableOutletSub = availableOutletSub;
    selectedCurrency = super.availableCurrencies[0];
    selectedOutletSub = currentOutletSub;
  }

  MutasiPageIdleState({
    Currency? currency,
    Currency? toCurrency,
    OutletSub? outletSub,
    bool? useFilter,
    FilterPanelState? isFilterPanelOpen,
    DateTime? startDate,
    DateTime? toDate,
    UserData? userData,
    List<Currency>? availableCurrencies,
    List<Currency>? availableToCurrencies,
    List<OutletSub>? availableOutletSub,
    double inputValue = 0,
    double outputValue = 0,
    ConnectivityState? connectionStatus,
    MutasiInputState inputState = const MutasiFormInputIdle(),
  }) {
    super.inputState = inputState;
    super.inputValue = inputValue;
    super.outputValue = outputValue;
    if (useFilter != null) {
      super.useFilter = useFilter;
    }
    if (userData != null) {
      currentUser = userData;
    }
    if (isFilterPanelOpen != null) {
      super.filterPanelState = isFilterPanelOpen;
    }
    if (startDate != null) {
      super.startDate = startDate;
    }
    if (toDate != null) {
      super.toDate = toDate;
    }

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

  MutasiPageIdleState copyWith({
    Currency? currency,
    Currency? toCurrency,
    FilterPanelState? statePanel,
    double? inputValue,
    double? outputValue,
    DateTime? startDate,
    bool? useFilter,
    DateTime? toDate,
    List<Currency>? availableCurrencies,
    List<Currency>? availableToCurrencies,
    List<OutletSub>? availableOutletSub,
    OutletSub? outletSub,
    UserData? userData,
    ConnectivityState? connectionStatus,
    MutasiInputState? inputState,
  }) {
    return MutasiPageIdleState(
      useFilter: useFilter ?? this.useFilter,
      userData: userData ?? currentUser,
      isFilterPanelOpen: statePanel ?? filterPanelState,
      availableToCurrencies:
          availableToCurrencies ?? this.availableToCurrencies,
      startDate: startDate ?? this.startDate,
      toDate: toDate ?? this.toDate,
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

abstract class FilterPanelState {
  const FilterPanelState();
}

class PanelOpening extends FilterPanelState {
  const PanelOpening();
}

class PanelOpened extends FilterPanelState {
  const PanelOpened();
}

class PanelClosed extends FilterPanelState {
  const PanelClosed();
}

abstract class MutasiInputState {
  const MutasiInputState();
}

class MutasiFormSubmitting extends MutasiInputState {}

class MutasiFormSuccess extends MutasiInputState {}

class MutasiFormFailed extends MutasiInputState {
  final String message;
  MutasiFormFailed({required this.message});
}

class MutasiFormInteruptedByConnection extends MutasiInputState {
  const MutasiFormInteruptedByConnection();
}

class MutasiFormBadInputState extends MutasiInputState {
  final String message;
  final int badInputCode;
  MutasiFormBadInputState({required this.message, required this.badInputCode});
}

class MutasiFormInputIdle extends MutasiInputState {
  const MutasiFormInputIdle();
}
