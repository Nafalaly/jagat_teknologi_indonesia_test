// ignore_for_file: depend_on_referenced_packages

import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/services/preferences/user_account.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_account_state.dart';

class UserAccountCubit extends Cubit<UserAccountState> {
  UserAccountCubit() : super(UserAccountInitial());

  UserAccountPreferences preferences = UserAccountPreferences();

  Future<void> loadFromPreferences() async {
    UserData data = await preferences.getPrefAccount();
    if (data.statusLog) {
      emit(UserAccountAttached(accountData: data));
    } else {
      emit(UserAccountNoAccountInformation());
    }
  }

  Future<void> setAccount({required UserData newAccount}) async {
    await preferences.setUser(account: newAccount);
    emit(UserAccountAttached(accountData: newAccount));
  }

  Future<void> logOutAccount() async {
    await preferences.logOut();
    emit(UserAccountNoAccountInformation());
  }
}
