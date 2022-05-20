// ignore_for_file: prefer_final_fields

part of 'models.dart';

class UserData {
  late String userId;
  late String language;
  late String fullName;
  late String phone;
  late String emailAddress;
  late UserStatus role;
  late String? designation;
  late String? outletId;
  bool statusLog = false;
  String token = 'No Token';
  UserData();
  UserData.fromPref({
    required this.userId,
    required this.language,
    required this.fullName,
    required this.phone,
    required this.emailAddress,
    required this.role,
    required this.designation,
    required this.outletId,
    required this.token,
    required this.statusLog,
  });

  UserData.fromJson({required Map data}) {
    // token = '${data['token_type']} ${data['token_result']}';
    userId = data['user']['user_id'];
    language = data['user']['language'];
    fullName = data['user']['full_name'];
    phone = data['user']['phone'];
    emailAddress = data['user']['email_address'];
    role = getStatusFromSTR(data: data['user']['role']);
    designation = data['user']['designation'];
    outletId = data['user']['outlet_id'];
    statusLog = true;
  }
}
