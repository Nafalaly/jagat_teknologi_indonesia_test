part of 'pindah_page_bloc.dart';

@immutable
abstract class PindahPageEvent {}

//Attempt
class PindahSubmitAttemptEvent extends PindahPageEvent {}

//Photo Process
class PindahAddPicture extends PindahPageEvent {
  final ImageSource source;
  PindahAddPicture({required this.source});
}
//Attribute Changes

class PindahSubOutletChangeEvent extends PindahPageEvent {
  final OutletSub newOutlet;
  PindahSubOutletChangeEvent({required this.newOutlet});
}

class PindahToSubOutletChangeEvent extends PindahPageEvent {
  final OutletSub newOutlet;
  PindahToSubOutletChangeEvent({required this.newOutlet});
}

class PindahCurrencyChangeEvent extends PindahPageEvent {
  final Currency newCurrency;
  PindahCurrencyChangeEvent({required this.newCurrency});
}

class PindahStartDateChangeEvent extends PindahPageEvent {
  final DateTime newDate;
  PindahStartDateChangeEvent({required this.newDate});
}

class PindahInputValueChangeEvent extends PindahPageEvent {
  late final double newValue;
  PindahInputValueChangeEvent({required String newValue}) {
    try {
      this.newValue = double.parse(newValue);
    } on FormatException {
      this.newValue = 0;
    }
  }
}

class PindahAddPictureEvent extends PindahPageEvent {
  final File file;
  PindahAddPictureEvent({required this.file});
}

class PindahRemovePictureEvent extends PindahPageEvent {
  final int indexPicture;
  PindahRemovePictureEvent({required this.indexPicture});
}

class PindahDescriptionChangeEvent extends PindahPageEvent {
  final String newDesc;
  PindahDescriptionChangeEvent({required this.newDesc});
}

// Attempt Result

class PindahAttemptSuccess extends PindahPageEvent {}

class PindahAttemptFailed extends PindahPageEvent {
  final String message;
  PindahAttemptFailed({required this.message});
}

class PindahConnectionWarningDismiss extends PindahPageEvent {}

class PindahInteruptedByConnection extends PindahPageEvent {}

class PindahConnectionEstablished extends PindahPageEvent {}

//Input behavior

class PindahDismissFormState extends PindahPageEvent {}

class PindahBadInput extends PindahPageEvent {
  final String message;
  final int badInputCode;
  PindahBadInput({required this.message, required this.badInputCode});
}
