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

part 'outcome_page_event.dart';
part 'outcome_page_state.dart';

class OutcomePageBloc extends Bloc<OutcomePageEvent, OutcomePageState> {
  OutcomePageBloc(
      {required List<Currency> availableCurrencies,
      required List<OutletSub> availableOutletSub,
      required OutletSub currentOutletSub,
      required UserData current,
      required this.connection})
      : super(OutcomePageIdleState.setInitialData(
            availableCurrencies: availableCurrencies,
            currentUser: current,
            availableOutletSub: availableOutletSub,
            currentOutletSub: currentOutletSub,
            connection: connection.state)) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(OutcomeConnectionEstablished());
      } else {
        add(OutcomeInteruptedByConnection());
      }
    });
    on(mapEvent);
  }
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(
      OutcomePageEvent event, Emitter<OutcomePageState> emit) async {
    if (event is OutcomeSubOutletChangeEvent) {
      emit(
          (state as OutcomePageIdleState).copyWith(outletSub: event.newOutlet));
    } else if (event is OutcomeCurrencyChangeEvent) {
      emit((state as OutcomePageIdleState)
          .copyWith(currency: event.newCurrency));
    } else if (event is OutcomeInputValueChangeEvent) {
      emit(
          (state as OutcomePageIdleState).copyWith(inputValue: event.newValue));
    } else if (event is OutcomeAddPicture) {
      addPictures(await getimage(event.source));
    } else if (event is OutcomeAddPictureEvent) {
      emit((state as OutcomePageIdleState).copyWith(
          pictures: (state as OutcomePageIdleState).pictures..add(event.file)));
    } else if (event is OutcomeRemovePictureEvent) {
      emit((state as OutcomePageIdleState).copyWith(
          pictures: (state as OutcomePageIdleState).pictures
            ..removeAt(event.indexPicture)));
    } else if (event is OutcomeDescriptionChangeEvent) {
      emit((state as OutcomePageIdleState).copyWith(desc: event.newDesc));
    } else if (event is OutcomeStartDateChangeEvent) {
      emit((state as OutcomePageIdleState).copyWith(time: event.newDate));
    } else if (event is OutcomeSubmitAttemptEvent) {
      String? errorMessage = (state as OutcomePageIdleState).validator();
      if (errorMessage != null) {
        add(OutcomeBadInput(message: errorMessage));
      } else {
        if ((state as OutcomePageIdleState).connectionStatus
            is InternetConnected) {
          uploadData();
        } else {
          add(OutcomeInteruptedByConnection());
        }
      }
    } else if (event is OutcomeConnectionEstablished) {
      emit((state as OutcomePageIdleState)
          .copyWith(connectionStatus: const InternetConnected()));
    } else if (event is OutcomeInteruptedByConnection) {
      emit((state as OutcomePageIdleState).copyWith(
          connectionStatus: const NoInternetConnections(),
          inputState: const OutcomeFormInteruptedByConnection()));
    } else if (event is OutcomeBadInput) {
      emit((state as OutcomePageIdleState).copyWith(
          inputState: OutcomeFormBadInputState(message: event.message)));
    } else if (event is OutcomeDismissFormState ||
        event is OutcomeConnectionWarningDismiss) {
      emit((state as OutcomePageIdleState)
          .copyWith(inputState: const OutcomeFormInputIdle()));
    } else if (event is OutcomeAttemptSuccess) {
      emit((state as OutcomePageIdleState)
          .copyWith(inputState: OutcomeFormSuccess()));
    } else if (event is OutcomeAttemptFailed) {
      emit((state as OutcomePageIdleState)
          .copyWith(inputState: OutcomeFormFailed(message: event.message)));
    }
  }

  APITransaction apiTransaction = APITransaction();

  Future<void> uploadData() async {
    // ResponseParser result = await apiTransaction.incomeService(
    //     state: (state as OutcomePageIdleState));
    // if (result.getStatus == ResponseStatus.success) {
    //   add(OutcomeAttemptSuccess());
    //   // add(LoginAttemptSucessfully());
    // } else {
    //   add(OutcomeAttemptFailed(message: 'Something went wrong'));
    //   // if (result.getStatusCode == 1002) {
    //   //   add(LoginFailed(message: 'Username atau password salah'));
    //   // } else {
    //   //   add(LoginFailed(message: 'Something went wrong'));
    //   // }
    // }
    // return;
  }

  Future<void> addPictures(File? file) async {
    if (file == null) {
      return;
    } else {
      add(OutcomeAddPictureEvent(file: file));
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
