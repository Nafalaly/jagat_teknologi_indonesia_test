// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:meta/meta.dart';

part 'outlet_state.dart';

class OutletCubit extends Cubit<OutletState> {
  OutletCubit() : super(OutletInitial());

  Future<void> setData({required Outlet outlet}) async {
    emit(OutletIdleState(outlet: outlet));
  }

  void setError() {
    emit(OutletErrorOccurred());
  }

  void setNodata() {
    emit(OutletNoData());
  }
}
