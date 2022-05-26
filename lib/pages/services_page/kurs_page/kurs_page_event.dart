part of 'kurs_page_bloc.dart';

@immutable
abstract class KursPageEvent {}

//Attempt
class KursSubmitAttemptEvent extends KursPageEvent {}

//Attribute Changes

class KursSubOutletChangeEvent extends KursPageEvent {
  final OutletSub newOutlet;
  KursSubOutletChangeEvent({required this.newOutlet});
}

class KursCurrencyChangeEvent extends KursPageEvent {
  final Currency newCurrency;
  KursCurrencyChangeEvent({required this.newCurrency});
}

class KursCurrencyToChangeEvent extends KursPageEvent {
  final Currency newCurrency;
  KursCurrencyToChangeEvent({required this.newCurrency});
}

class KursInputValueChangeEvent extends KursPageEvent {
  late final double newValue;
  KursInputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

class KursOutputValueChangeEvent extends KursPageEvent {
  late final double newValue;
  KursOutputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

// Attempt Result

class KursAttemptSuccess extends KursPageEvent {}

class KursAttemptFailed extends KursPageEvent {
  final String message;
  KursAttemptFailed({required this.message});
}

class KursConnectionWarningDismiss extends KursPageEvent {}

class KursInteruptedByConnection extends KursPageEvent {}

class KursConnectionEstablished extends KursPageEvent {}

//Input behavior

class KursDismissFormState extends KursPageEvent {}

class KursBadInput extends KursPageEvent {
  final String message;
  final int badInputCode;
  KursBadInput({required this.message, required this.badInputCode});
}
