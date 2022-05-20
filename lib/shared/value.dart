part of 'shared.dart';

enum UserStatus {
  admin,
  leader,
  worker,
  defaultStatus,
}

String getSTRfromStatus({required UserStatus status}) {
  switch (status) {
    case UserStatus.leader:
      return 'LEADER';
    case UserStatus.worker:
      return 'WORKER';
    case UserStatus.admin:
      return 'ADMIN';
    default:
      return 'undefined';
  }
}

enum DataSource { link, custom }

String getStrFromSource(DataSource source) {
  switch (source) {
    case DataSource.link:
      return 'link';
    case DataSource.custom:
      return 'custom';
  }
}

UserStatus getStatusFromSTR({required String data}) {
  switch (data) {
    case 'WORKER':
      return UserStatus.worker;
    case 'ADMIN':
      return UserStatus.admin;
    case 'LEADER':
      return UserStatus.leader;
    default:
      return UserStatus.defaultStatus;
  }
}
