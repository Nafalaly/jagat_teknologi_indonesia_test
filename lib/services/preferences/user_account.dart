import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountPreferences {
  static const String logstatus = "_statuslog";
  static const String userId = "user_id";
  static const String languageStr = "language";
  static const String fullNameStr = "full_name";
  static const String userPhoneStr = "user_phone";
  static const String userEmailStr = "user_email";
  static const String roleStatusStr = "role";
  static const String designationStr = "designation";
  static const String outletIdStr = "outlet_id";
  static const String tokenSTR = "token";

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
    pref.setString(UserAccountPreferences.languageStr, account.language);
    pref.setString(UserAccountPreferences.userId, account.userId);
    pref.setString(UserAccountPreferences.userEmailStr, account.emailAddress);
    pref.setString(UserAccountPreferences.userPhoneStr, account.phone);
    pref.setString(UserAccountPreferences.tokenSTR, account.token);
    pref.setBool(UserAccountPreferences.logstatus, true);
    pref.setString(UserAccountPreferences.roleStatusStr,
        getSTRfromStatus(status: account.role));
    return;
  }

  Future<UserData> getPrefAccount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return UserData.fromPref(
        designation: pref.getString(designationStr).toString(),
        emailAddress: pref.getString(userEmailStr).toString(),
        fullName: pref.getString(fullNameStr).toString(),
        language: pref.getString(languageStr).toString(),
        outletId: pref.getString(outletIdStr).toString(),
        phone: pref.getString(userPhoneStr).toString(),
        role: getStatusFromSTR(data: pref.getString(roleStatusStr).toString()),
        statusLog: pref.getBool(logstatus) ?? false,
        token: pref.getString(tokenSTR).toString(),
        userId: pref.getString(userId).toString());
  }
}
