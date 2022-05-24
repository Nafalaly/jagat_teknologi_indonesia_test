// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';

part 'income_page_event.dart';
part 'income_page_state.dart';

class IncomePageBloc extends Bloc<IncomePageEvent, IncomePageState> {
  IncomePageBloc(
      {required List<Currency> availableCurrencies,
      required List<OutletSub> availableOutletSub,
      required OutletSub currentOutletSub,
      required UserData current,
      required this.connection})
      : super(IncomePageIdleState.setInitialData(
            availableCurrencies: availableCurrencies,
            currentUser: current,
            availableOutletSub: availableOutletSub,
            currentOutletSub: currentOutletSub,
            connection: connection.state)) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(IncomeConnectionEstablished());
      } else {
        add(IncomeInteruptedByConnection());
      }
    });
    on(mapEvent);
  }
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(
      IncomePageEvent event, Emitter<IncomePageState> emit) async {
    if (event is IncomeSubOutletChangeEvent) {
      emit((state as IncomePageIdleState).copyWith(outletSub: event.newOutlet));
    } else if (event is IncomeCurrencyChangeEvent) {
      emit(
          (state as IncomePageIdleState).copyWith(currency: event.newCurrency));
    } else if (event is IncomeInputValueChangeEvent) {
      emit((state as IncomePageIdleState).copyWith(inputValue: event.newValue));
    } else if (event is IncomeAddPicture) {
      addPictures(await getimage(event.source));
    } else if (event is IncomeAddPictureEvent) {
      emit((state as IncomePageIdleState).copyWith(
          pictures: (state as IncomePageIdleState).pictures..add(event.file)));
    } else if (event is IncomeRemovePictureEvent) {
      emit((state as IncomePageIdleState).copyWith(
          pictures: (state as IncomePageIdleState).pictures
            ..removeAt(event.indexPicture)));
    } else if (event is IncomeDescriptionChangeEvent) {
      emit((state as IncomePageIdleState).copyWith(desc: event.newDesc));
    } else if (event is IncomeStartDateChangeEvent) {
      emit((state as IncomePageIdleState).copyWith(time: event.newDate));
    } else if (event is IncomeSubmitAttemptEvent) {
      int? errorCodes = (state as IncomePageIdleState).validator();
      if (errorCodes != null) {
        switch (errorCodes) {
          case 501:
            add(IncomeBadInput(
                message: 'Nominal tidak boleh 0', badInputCode: errorCodes));
            break;
          case 502:
            add(IncomeBadInput(
                message: 'Upload Gambar minimal 1', badInputCode: errorCodes));
            break;
          default:
            add(IncomeBadInput(message: 'Bad Input State', badInputCode: 0));
            break;
        }
      } else {
        if ((state as IncomePageIdleState).connectionStatus
            is InternetConnected) {
          uploadData();
        } else {
          add(IncomeInteruptedByConnection());
        }
      }
    } else if (event is IncomeConnectionEstablished) {
      emit((state as IncomePageIdleState)
          .copyWith(connectionStatus: const InternetConnected()));
    } else if (event is IncomeInteruptedByConnection) {
      emit((state as IncomePageIdleState).copyWith(
          connectionStatus: const NoInternetConnections(),
          inputState: const IncomeFormInteruptedByConnection()));
    } else if (event is IncomeBadInput) {
      emit((state as IncomePageIdleState).copyWith(
          inputState: IncomeFormBadInputState(
        message: event.message,
        badInputCode: event.badInputCode,
      )));
    } else if (event is IncomeDismissFormState ||
        event is IncomeConnectionWarningDismiss) {
      emit((state as IncomePageIdleState)
          .copyWith(inputState: const IncomeFormInputIdle()));
    } else if (event is IncomeAttemptSuccess) {
      emit((state as IncomePageIdleState)
          .copyWith(inputState: IncomeFormSuccess()));
    } else if (event is IncomeAttemptFailed) {
      emit((state as IncomePageIdleState)
          .copyWith(inputState: IncomeFormFailed(message: event.message)));
    }
  }

  APITransaction apiTransaction = APITransaction();

  Future<void> uploadData() async {
    ResponseParser result = await apiTransaction.uploadIncomeOutCome(
        state: (state as IncomePageIdleState));
    if (result.getStatus == ResponseStatus.success) {
      add(IncomeAttemptSuccess());
    } else {
      add(IncomeAttemptFailed(message: 'Something went wrong'));
    }
    return;
  }

  Future<void> addPictures(File? file) async {
    if (file == null) {
      return;
    } else {
      add(IncomeAddPictureEvent(file: file));
    }
  }

  Future<File?> getimage(ImageSource source) async {
    ImagePicker pick = ImagePicker();
    // ignore: deprecated_member_use
    PickedFile? image = await pick.getImage(source: source);
    if (image != null) {
      ImageCropper cropper = ImageCropper();
      var cropped = await cropper.cropImage(
          sourcePath: image.path,
          // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
          ],
          compressQuality: 80,
          maxWidth: 800,
          maxHeight: 800,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.lightBlueAccent,
              toolbarTitle: "Crop Image",
              statusBarColor: Colors.blue,
              backgroundColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.blue,
            )
          ]);
      return File(cropped!.path);
    }
    return null;
  }

  @override
  Future<void> close() {
    connectionMonitor.cancel();
    return super.close();
  }
}
