part of 'shared.dart';

enum UserStatus {
  admin,
  user,
  manager,
  defaultStatus,
}

String getSTRfromStatus({required UserStatus status}) {
  switch (status) {
    case UserStatus.user:
      return 'User';
    case UserStatus.manager:
      return 'Manager';
    case UserStatus.admin:
      return 'Admin';
    default:
      return 'undefined';
  }
}

UserStatus getStatusFromSTR({required String data}) {
  switch (data) {
    case 'Admin':
      return UserStatus.admin;
    case 'User':
      return UserStatus.user;
    case 'Manager':
      return UserStatus.manager;
    default:
      return UserStatus.defaultStatus;
  }
}
