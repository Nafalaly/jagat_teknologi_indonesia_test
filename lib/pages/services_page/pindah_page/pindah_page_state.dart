// ignore_for_file: must_be_immutable

part of 'pindah_page_bloc.dart';

@immutable
abstract class PindahPageState {
  late List<Currency> availableCurrencies = [];
  late List<OutletSub> availableOutletSub = [];
  late List<OutletSub> availableToOutletSub = [];
  late UserData currentUser = UserData();
  late ConnectivityState connectionStatus = const InternetInitial();
  late Currency? selectedCurrency;
  late OutletSub? selectedOutletSub = OutletSub.dummy();
  late OutletSub? selectedToOutletSub = OutletSub.dummy();
  DateTime startDate = DateTime.now();
  late List<File> pictures = [];
  late double inputValue = 0;
  late String desc = '';
  late PindahInputState inputState = const PindahFormInputIdle();
}

class PindahPageInitial extends PindahPageState {}

class PindahPageErrorState extends PindahPageState {
  final String errorMessage;
  PindahPageErrorState({required this.errorMessage});
}

class PindahPageIdleState extends PindahPageState {
  List<PictureWidget> getPicturesWidget() {
    List<PictureWidget> finalWidget =
        List.generate(4, (index) => PictureWidget());

    for (int i = 0; i < finalWidget.length; i++) {
      try {
        // ignore: unnecessary_null_comparison
        if (pictures[i] != null) {
          finalWidget[i].fileImg = pictures[i];
          finalWidget[i].isDummy = false;
        }
        // ignore: empty_catches
      } on RangeError {}
    }
    return finalWidget;
  }

  int? validator() {
    if (super.selectedToOutletSub!.id == null) {
      //Outlet tujuan kosong
      return 501;
    }
    if (super.selectedToOutletSub!.id == super.selectedOutletSub!.id) {
      //Outlet tujuan dan asal sama
      return 502;
    }
    if (inputValue == 0) {
      return 503;
    }
    if (pictures.isEmpty) {
      return 504;
    }
    return null;
  }

  PindahPageIdleState.setInitialData({
    required List<Currency> availableCurrencies,
    required List<OutletSub> availableOutletSub,
    required OutletSub currentOutletSub,
    required UserData currentUser,
    required ConnectivityState connection,
  }) {
    super.connectionStatus = connection;
    super.currentUser = currentUser;
    super.availableCurrencies = availableCurrencies;
    super.availableOutletSub = availableOutletSub;
    selectedToOutletSub = OutletSub.dummy();
    super.availableToOutletSub = List.from(availableOutletSub);
    super.availableToOutletSub.add(selectedToOutletSub!);
    selectedOutletSub = currentOutletSub;
    selectedCurrency = super.availableCurrencies[0];
    startDate = DateTime.now();
  }

  PindahPageIdleState({
    DateTime? time,
    Currency? currency,
    OutletSub? outletSub,
    OutletSub? toOutletSub,
    List<File>? pictures,
    List<Currency>? availableCurrencies,
    List<OutletSub>? availableOutletSub,
    List<OutletSub>? availableToOutletSub,
    UserData? userData,
    double inputValue = 0,
    String desc = '',
    ConnectivityState? connectionStatus,
    PindahInputState inputState = const PindahFormInputIdle(),
  }) {
    super.inputState = inputState;
    super.inputValue = inputValue;
    super.desc = desc;
    if (availableToOutletSub != null) {
      super.availableToOutletSub = availableToOutletSub;
    }

    if (connectionStatus != null) {
      super.connectionStatus = connectionStatus;
    }
    if (userData != null) {
      currentUser = userData;
    }
    if (availableOutletSub != null) {
      this.availableOutletSub = availableOutletSub;
    }
    if (availableCurrencies != null) {
      this.availableCurrencies = availableCurrencies;
    }
    if (currency != null) {
      selectedCurrency = currency;
    }
    if (time != null) {
      startDate = time;
    }

    if (outletSub != null) {
      selectedOutletSub = outletSub;
    }
    if (toOutletSub != null) {
      super.selectedToOutletSub = toOutletSub;
    }

    if (pictures != null) {
      this.pictures = pictures;
    }
  }

  PindahPageIdleState copyWith({
    DateTime? time,
    Currency? currency,
    List<File>? pictures,
    double? inputValue,
    String? desc,
    List<Currency>? availableCurrencies,
    List<OutletSub>? availableOutletSub,
    List<OutletSub>? availableToOutletSub,
    UserData? userData,
    OutletSub? outletSub,
    OutletSub? toOutletSub,
    ConnectivityState? connectionStatus,
    PindahInputState? inputState,
  }) {
    return PindahPageIdleState(
      userData: userData ?? currentUser,
      time: time ?? startDate,
      desc: desc ?? this.desc,
      currency: currency ?? selectedCurrency,
      pictures: pictures ?? this.pictures,
      toOutletSub: toOutletSub ?? selectedToOutletSub,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      availableOutletSub: availableOutletSub ?? this.availableOutletSub,
      availableToOutletSub: availableToOutletSub ?? this.availableToOutletSub,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      outletSub: outletSub ?? selectedOutletSub,
      inputState: inputState ?? this.inputState,
      inputValue: inputValue ?? this.inputValue,
    );
  }
}

abstract class PindahInputState {
  const PindahInputState();
}

class PindahFormSubmitting extends PindahInputState {}

class PindahFormSuccess extends PindahInputState {}

class PindahFormFailed extends PindahInputState {
  final String message;
  PindahFormFailed({required this.message});
}

class PindahFormInteruptedByConnection extends PindahInputState {
  const PindahFormInteruptedByConnection();
}

class PindahFormBadInputState extends PindahInputState {
  final String message;
  final int badInputCode;
  PindahFormBadInputState({required this.message, required this.badInputCode});
}

class PindahFormInputIdle extends PindahInputState {
  const PindahFormInputIdle();
}
