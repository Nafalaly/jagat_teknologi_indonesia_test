// ignore_for_file: must_be_immutable

part of 'income_page_bloc.dart';

@immutable
abstract class IncomePageState {
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
  late IncomeInputState inputState = const IncomeFormInputIdle();
}

class IncomePageInitial extends IncomePageState {}

class IncomePageErrorState extends IncomePageState {
  final String errorMessage;
  IncomePageErrorState({required this.errorMessage});
}

class PictureWidget {
  File? fileImg;
  bool isDummy;

  PictureWidget({this.isDummy = true, this.fileImg});
}

class IncomePageIdleState extends IncomePageState {
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

  IncomePageIdleState.setInitialData({
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

  IncomePageIdleState({
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
    IncomeInputState inputState = const IncomeFormInputIdle(),
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

  IncomePageIdleState copyWith({
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
    IncomeInputState? inputState,
  }) {
    return IncomePageIdleState(
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

abstract class IncomeInputState {
  const IncomeInputState();
}

class IncomeFormSubmitting extends IncomeInputState {}

class IncomeFormSuccess extends IncomeInputState {}

class IncomeFormFailed extends IncomeInputState {
  final String message;
  IncomeFormFailed({required this.message});
}

class IncomeFormInteruptedByConnection extends IncomeInputState {
  const IncomeFormInteruptedByConnection();
}

class IncomeFormBadInputState extends IncomeInputState {
  final String message;
  final int badInputCode;
  IncomeFormBadInputState({required this.message, required this.badInputCode});
}

class IncomeFormInputIdle extends IncomeInputState {
  const IncomeFormInputIdle();
}
