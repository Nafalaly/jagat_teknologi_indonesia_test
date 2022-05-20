// ignore_for_file: prefer_final_fields

part of 'models.dart';

class UserData with User {
  UserData();
  UserData.fromPref(
      {required this.token,
      required String email,
      required String name,
      required String username,
      required String phone,
      required UserStatus role,
      required this.statusLog}) {
    super.userRole = role;
    super.userEmail = email;
    super.userName = username;
    super.userNameOfUser = name;
    super.userPhone = phone;
  }
  bool statusLog = false;
  String token = 'No Token';
  UserData.fromJson({required Map data}) {
    token = '${data['token_type']} ${data['token_result']}';
    super.userRole = getStatusFromSTR(data: data['user']['role']);
    super.userEmail = data['user']['email'];
    super.userName = data['user']['username'];
    super.userNameOfUser = data['user']['name'];
    super.userPhone = data['user']['phone'];
    statusLog = true;
  }
}

abstract class User {
  UserStatus userRole = UserStatus.defaultStatus;
  String userName = 'No name';
  String userNameOfUser = 'No Name';
  String userEmail = 'No Email';
  String userPhone = 'No Phone';
}
