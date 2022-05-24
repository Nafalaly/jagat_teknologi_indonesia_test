part of 'income_page_bloc.dart';

@immutable
abstract class IncomePageEvent {}

//Attempt
class IncomeSubmitAttemptEvent extends IncomePageEvent {}

//Photo Process
class IncomeAddPicture extends IncomePageEvent {
  final ImageSource source;
  IncomeAddPicture({required this.source});
}
//Attribute Changes

class IncomeSubOutletChangeEvent extends IncomePageEvent {
  final OutletSub newOutlet;
  IncomeSubOutletChangeEvent({required this.newOutlet});
}

class IncomeCurrencyChangeEvent extends IncomePageEvent {
  final Currency newCurrency;
  IncomeCurrencyChangeEvent({required this.newCurrency});
}

class IncomeStartDateChangeEvent extends IncomePageEvent {
  final DateTime newDate;
  IncomeStartDateChangeEvent({required this.newDate});
}

class IncomeInputValueChangeEvent extends IncomePageEvent {
  late final double newValue;
  IncomeInputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

class IncomeAddPictureEvent extends IncomePageEvent {
  final File file;
  IncomeAddPictureEvent({required this.file});
}

class IncomeRemovePictureEvent extends IncomePageEvent {
  final int indexPicture;
  IncomeRemovePictureEvent({required this.indexPicture});
}

class IncomeDescriptionChangeEvent extends IncomePageEvent {
  final String newDesc;
  IncomeDescriptionChangeEvent({required this.newDesc});
}

// Attempt Result

class IncomeAttemptSuccess extends IncomePageEvent {}

class IncomeAttemptFailed extends IncomePageEvent {
  final String message;
  IncomeAttemptFailed({required this.message});
}

class IncomeConnectionWarningDismiss extends IncomePageEvent {}

class IncomeInteruptedByConnection extends IncomePageEvent {}

class IncomeConnectionEstablished extends IncomePageEvent {}

//Input behavior

class IncomeDismissFormState extends IncomePageEvent {}

class IncomeBadInput extends IncomePageEvent {
  final String message;
  IncomeBadInput({required this.message});
}
