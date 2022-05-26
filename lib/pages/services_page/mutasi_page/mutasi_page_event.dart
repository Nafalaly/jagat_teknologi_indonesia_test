part of 'mutasi_page_bloc.dart';

@immutable
abstract class MutasiPageEvent {}

//Attempt
class MutasiSubmitAttemptEvent extends MutasiPageEvent {}

//Attribute Changes

class MutasiOpenFilterPanelEvent extends MutasiPageEvent {
  MutasiOpenFilterPanelEvent();
}

class MutasiUseFilterSwitch extends MutasiPageEvent {
  final bool switchState;
  MutasiUseFilterSwitch({required this.switchState});
}

class MutasiCloseFilterPanelEvent extends MutasiPageEvent {
  MutasiCloseFilterPanelEvent();
}

class MutasiStartDateChangeEvent extends MutasiPageEvent {
  final DateTime newDate;
  MutasiStartDateChangeEvent({required this.newDate});
}

class MutasiToDateChangeEvent extends MutasiPageEvent {
  final DateTime newDate;
  MutasiToDateChangeEvent({required this.newDate});
}

class MutasiSubOutletChangeEvent extends MutasiPageEvent {
  final OutletSub newOutlet;
  MutasiSubOutletChangeEvent({required this.newOutlet});
}

class MutasiCurrencyChangeEvent extends MutasiPageEvent {
  final Currency newCurrency;
  MutasiCurrencyChangeEvent({required this.newCurrency});
}

class MutasiCurrencyToChangeEvent extends MutasiPageEvent {
  final Currency newCurrency;
  MutasiCurrencyToChangeEvent({required this.newCurrency});
}

class MutasiInputValueChangeEvent extends MutasiPageEvent {
  late final double newValue;
  MutasiInputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

class MutasiOutputValueChangeEvent extends MutasiPageEvent {
  late final double newValue;
  MutasiOutputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

// Attempt Result

class MutasiAttemptSuccess extends MutasiPageEvent {}

class MutasiAttemptFailed extends MutasiPageEvent {
  final String message;
  MutasiAttemptFailed({required this.message});
}

class MutasiConnectionWarningDismiss extends MutasiPageEvent {}

class MutasiInteruptedByConnection extends MutasiPageEvent {}

class MutasiConnectionEstablished extends MutasiPageEvent {}

//Input behavior

class MutasiDismissFormState extends MutasiPageEvent {}

class MutasiBadInput extends MutasiPageEvent {
  final String message;
  final int badInputCode;
  MutasiBadInput({required this.message, required this.badInputCode});
}
