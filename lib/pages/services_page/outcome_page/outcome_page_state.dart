// ignore_for_file: must_be_immutable

part of 'outcome_page_bloc.dart';

@immutable
abstract class OutcomePageState {
  late List<Currency> availableCurrencies = [];
  late List<OutletSub> availableOutletSub = [];
  late UserData currentUser = UserData();
  late ConnectivityState connectionStatus = const InternetInitial();
  late Currency? selectedCurrency;
  late OutletSub? selectedOutletSub;
  DateTime startDate = DateTime.now();
  late List<File> pictures = [];
  late double inputValue = 0;
  late String desc = '';
  late OutcomeInputState inputState = const OutcomeFormInputIdle();
}

class OutcomePageInitial extends OutcomePageState {}

class OutcomePageErrorState extends OutcomePageState {
  final String errorMessage;
  OutcomePageErrorState({required this.errorMessage});
}

class PictureWidget {
  File? fileImg;
  bool isDummy;

  PictureWidget({this.isDummy = true, this.fileImg});
}

class OutcomePageIdleState extends OutcomePageState {
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
    if (inputValue == 0) {
      return 501;
    }
    if (pictures.isEmpty) {
      return 502;
    }
    return null;
  }

  OutcomePageIdleState.setInitialData({
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
    selectedCurrency = super.availableCurrencies[0];
    selectedOutletSub = currentOutletSub;
    startDate = DateTime.now();
  }

  OutcomePageIdleState({
    DateTime? time,
    Currency? currency,
    OutletSub? outletSub,
    List<File>? pictures,
    List<Currency>? availableCurrencies,
    List<OutletSub>? availableOutletSub,
    UserData? userData,
    double inputValue = 0,
    String desc = '',
    ConnectivityState? connectionStatus,
    OutcomeInputState inputState = const OutcomeFormInputIdle(),
  }) {
    super.inputState = inputState;
    super.inputValue = inputValue;
    super.desc = desc;
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

    if (pictures != null) {
      this.pictures = pictures;
    }
  }

  OutcomePageIdleState copyWith({
    DateTime? time,
    Currency? currency,
    List<File>? pictures,
    double? inputValue,
    String? desc,
    List<Currency>? availableCurrencies,
    List<OutletSub>? availableOutletSub,
    UserData? userData,
    OutletSub? outletSub,
    ConnectivityState? connectionStatus,
    OutcomeInputState? inputState,
  }) {
    return OutcomePageIdleState(
      userData: userData ?? currentUser,
      time: time ?? startDate,
      desc: desc ?? this.desc,
      currency: currency ?? selectedCurrency,
      pictures: pictures ?? this.pictures,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      availableOutletSub: availableOutletSub ?? this.availableOutletSub,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      outletSub: outletSub ?? selectedOutletSub,
      inputState: inputState ?? this.inputState,
      inputValue: inputValue ?? this.inputValue,
    );
  }
}

abstract class OutcomeInputState {
  const OutcomeInputState();
}

class OutcomeFormSubmitting extends OutcomeInputState {}

class OutcomeFormSuccess extends OutcomeInputState {}

class OutcomeFormFailed extends OutcomeInputState {
  final String message;
  OutcomeFormFailed({required this.message});
}

class OutcomeFormInteruptedByConnection extends OutcomeInputState {
  const OutcomeFormInteruptedByConnection();
}

class OutcomeFormBadInputState extends OutcomeInputState {
  final String message;
  final int badInputCode;
  OutcomeFormBadInputState({required this.message, required this.badInputCode});
}

class OutcomeFormInputIdle extends OutcomeInputState {
  const OutcomeFormInputIdle();
}
