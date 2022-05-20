import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountPreferences {
  static const String logstatus = "_statuslog";
  static const String userNameStr = "user_name";
  static const String userEmailStr = "user_email";
  static const String userPhoneStr = "user_phone";
  static const String roleStatusStr = "is_admin";
  static const String usernameSTR = "username";
  static const String tokenSTR = "token";

  UserStatus _role = UserStatus.defaultStatus;
  String _userName = '';
  String _userNameOfUser = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userToken = '';

  Future<void> logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // const String nodata = 'No Data Avail';
    await pref.clear();
    // pref.setString(UserAccountPreferences.usernameSTR, nodata);
    // pref.setString(UserAccountPreferences.userNameStr, nodata);
    // pref.setString(UserAccountPreferences.userEmailStr, nodata);
    // pref.setString(UserAccountPreferences.userPhoneStr, nodata);
    // pref.setBool(UserAccountPreferences.roleStatusStr, false);
    // pref.setString(UserAccountPreferences.logstatus, nodata);
    // pref.setString(UserAccountPreferences.tokenSTR, nodata);
    return;
  }

  Future<void> setUser({required UserData account}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(UserAccountPreferences.usernameSTR, account.userName);
    pref.setString(UserAccountPreferences.userNameStr, account.userNameOfUser);
    pref.setString(UserAccountPreferences.userEmailStr, account.userEmail);
    pref.setString(UserAccountPreferences.userPhoneStr, account.userPhone);
    pref.setString(UserAccountPreferences.tokenSTR, account.token);
    pref.setBool(UserAccountPreferences.logstatus, true);
    pref.setString(UserAccountPreferences.roleStatusStr,
        getSTRfromStatus(status: account.userRole));
    return;
  }

  Future<UserData> getPrefAccount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _userToken = pref.getString(tokenSTR).toString();
    _userName = pref.getString(usernameSTR).toString();
    _userNameOfUser = pref.getString(userNameStr).toString();
    _userEmail = pref.getString(userEmailStr).toString();
    _userPhone = pref.getString(userPhoneStr).toString();
    _role = getStatusFromSTR(data: pref.getString(roleStatusStr).toString());
    // ignore: unnecessary_null_comparison
    bool log = _userToken != 'null';
    return UserData.fromPref(
        token: _userToken,
        statusLog: log,
        email: _userEmail,
        name: _userNameOfUser,
        username: _userName,
        phone: _userPhone,
        role: _role);
  }
}
