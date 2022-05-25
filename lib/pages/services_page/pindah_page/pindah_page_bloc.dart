// ignore_for_file: depend_on_referenced_packages, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/pages/services_page/income_page/income_page_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';

part 'pindah_page_event.dart';
part 'pindah_page_state.dart';

class PindahPageBloc extends Bloc<PindahPageEvent, PindahPageState> {
  PindahPageBloc(
      {required List<Currency> availableCurrencies,
      required List<OutletSub> availableOutletSub,
      required OutletSub currentOutletSub,
      required UserData current,
      required this.connection})
      : super(PindahPageIdleState.setInitialData(
            availableCurrencies: availableCurrencies,
            currentUser: current,
            availableOutletSub: availableOutletSub,
            currentOutletSub: currentOutletSub,
            connection: connection.state)) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(PindahConnectionEstablished());
      } else {
        add(PindahInteruptedByConnection());
      }
    });
    on(mapEvent);
  }
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(
      PindahPageEvent event, Emitter<PindahPageState> emit) async {
    if (event is PindahSubOutletChangeEvent) {
      emit((state as PindahPageIdleState).copyWith(outletSub: event.newOutlet));
    } else if (event is PindahToSubOutletChangeEvent) {
      emit((state as PindahPageIdleState)
          .copyWith(toOutletSub: event.newOutlet));
    } else if (event is PindahCurrencyChangeEvent) {
      emit(
          (state as PindahPageIdleState).copyWith(currency: event.newCurrency));
    } else if (event is PindahInputValueChangeEvent) {
      emit((state as PindahPageIdleState).copyWith(inputValue: event.newValue));
    } else if (event is PindahAddPicture) {
      addPictures(await getimage(event.source));
    } else if (event is PindahAddPictureEvent) {
      emit((state as PindahPageIdleState).copyWith(
          pictures: (state as PindahPageIdleState).pictures..add(event.file)));
    } else if (event is PindahRemovePictureEvent) {
      emit((state as PindahPageIdleState).copyWith(
          pictures: (state as PindahPageIdleState).pictures
            ..removeAt(event.indexPicture)));
    } else if (event is PindahDescriptionChangeEvent) {
      emit((state as PindahPageIdleState).copyWith(desc: event.newDesc));
    } else if (event is PindahStartDateChangeEvent) {
      emit((state as PindahPageIdleState).copyWith(time: event.newDate));
    } else if (event is PindahSubmitAttemptEvent) {
      int? errorCodes = (state as PindahPageIdleState).validator();
      if (errorCodes != null) {
        switch (errorCodes) {
          case 503:
            add(PindahBadInput(
                message: 'Nominal tidak boleh 0', badInputCode: errorCodes));
            break;
          case 504:
            add(PindahBadInput(
                message: 'Upload Gambar minimal 1', badInputCode: errorCodes));
            break;
          case 501:
            add(PindahBadInput(
                message: 'Outlet tujuan tidak boleh kosong',
                badInputCode: errorCodes));
            break;
          case 502:
            add(PindahBadInput(
                message: 'Outlet asal dengan tujuan haruslah berbeda',
                badInputCode: errorCodes));
            break;
          default:
            add(PindahBadInput(message: 'Bad Input State', badInputCode: 0));
            break;
        }
      } else {
        if ((state as PindahPageIdleState).connectionStatus
            is InternetConnected) {
          uploadData();
        } else {
          add(PindahInteruptedByConnection());
        }
      }
    } else if (event is PindahConnectionEstablished) {
      emit((state as PindahPageIdleState)
          .copyWith(connectionStatus: const InternetConnected()));
    } else if (event is PindahInteruptedByConnection) {
      emit((state as PindahPageIdleState).copyWith(
          connectionStatus: const NoInternetConnections(),
          inputState: const PindahFormInteruptedByConnection()));
    } else if (event is PindahBadInput) {
      emit((state as PindahPageIdleState).copyWith(
          inputState: PindahFormBadInputState(
              message: event.message, badInputCode: event.badInputCode)));
    } else if (event is PindahDismissFormState ||
        event is PindahConnectionWarningDismiss) {
      emit((state as PindahPageIdleState)
          .copyWith(inputState: const PindahFormInputIdle()));
    } else if (event is PindahAttemptSuccess) {
      emit((state as PindahPageIdleState)
          .copyWith(inputState: PindahFormSuccess()));
    } else if (event is PindahAttemptFailed) {
      emit((state as PindahPageIdleState)
          .copyWith(inputState: PindahFormFailed(message: event.message)));
    }
  }

  APITransaction apiTransaction = APITransaction();

  Future<void> uploadData() async {
    ResponseParser result =
        await apiTransaction.upload(state: (state as PindahPageIdleState));
    if (result.getStatus == ResponseStatus.success) {
      add(PindahAttemptSuccess());
    } else {
      add(PindahAttemptFailed(message: 'Something went wrong'));
    }
    return;
  }

  Future<void> addPictures(File? file) async {
    if (file == null) {
      return;
    } else {
      add(PindahAddPictureEvent(file: file));
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
