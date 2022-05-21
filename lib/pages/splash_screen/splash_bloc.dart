import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/user_account/user_account_cubit.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc({required this.accountCubit})
      : super(SplashScreenInitial()) {
    accountListener = accountCubit.stream.listen((state) {
      if (state is UserAccountAttached) {
        add(SplashScreenAccountLoaded());
      } else {
        add(SplashScreenNoAccountLoaded());
      }
    });
    on(mapEvent);
  }

  UserAccountCubit accountCubit;
  late StreamSubscription accountListener;

  Future<void> mapEvent(
      SplashScreenEvent event, Emitter<SplashScreenState> emit) async {
    if (event is SplashScreenLoadData) {
      emit(SplashScreenLoadingState());
      await accountCubit.loadFromPreferences();
    } else if (event is SplashScreenAccountLoaded) {
      emit(const SplashScreenLoadProcessComplete(hasAccount: true));
    } else if (event is SplashScreenNoAccountLoaded) {
      emit(const SplashScreenLoadProcessComplete(hasAccount: false));
    }
  }

  @override
  Future<void> close() {
    accountListener.cancel();
    return super.close();
  }
}
