part of 'outcome_page_bloc.dart';

@immutable
abstract class OutcomePageEvent {}

//Attempt
class OutcomeSubmitAttemptEvent extends OutcomePageEvent {}

//Photo Process
class OutcomeAddPicture extends OutcomePageEvent {
  final ImageSource source;
  OutcomeAddPicture({required this.source});
}
//Attribute Changes

class OutcomeSubOutletChangeEvent extends OutcomePageEvent {
  final OutletSub newOutlet;
  OutcomeSubOutletChangeEvent({required this.newOutlet});
}

class OutcomeCurrencyChangeEvent extends OutcomePageEvent {
  final Currency newCurrency;
  OutcomeCurrencyChangeEvent({required this.newCurrency});
}

class OutcomeStartDateChangeEvent extends OutcomePageEvent {
  final DateTime newDate;
  OutcomeStartDateChangeEvent({required this.newDate});
}

class OutcomeInputValueChangeEvent extends OutcomePageEvent {
  late final double newValue;
  OutcomeInputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

class OutcomeAddPictureEvent extends OutcomePageEvent {
  final File file;
  OutcomeAddPictureEvent({required this.file});
}

class OutcomeRemovePictureEvent extends OutcomePageEvent {
  final int indexPicture;
  OutcomeRemovePictureEvent({required this.indexPicture});
}

class OutcomeDescriptionChangeEvent extends OutcomePageEvent {
  final String newDesc;
  OutcomeDescriptionChangeEvent({required this.newDesc});
}

// Attempt Result

class OutcomeAttemptSuccess extends OutcomePageEvent {}

class OutcomeAttemptFailed extends OutcomePageEvent {
  final String message;
  OutcomeAttemptFailed({required this.message});
}

class OutcomeConnectionWarningDismiss extends OutcomePageEvent {}

class OutcomeInteruptedByConnection extends OutcomePageEvent {}

class OutcomeConnectionEstablished extends OutcomePageEvent {}

//Input behavior

class OutcomeDismissFormState extends OutcomePageEvent {}

class OutcomeBadInput extends OutcomePageEvent {
  final String message;
  OutcomeBadInput({required this.message});
}
