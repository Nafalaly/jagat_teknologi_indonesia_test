part of 'user_account_cubit.dart';

@immutable
abstract class UserAccountState {
  const UserAccountState();
}

class UserAccountInitial extends UserAccountState {}

class UserAccountLoading extends UserAccountState {}

class UserAccountAttached extends UserAccountState {
  final UserData accountData;
  const UserAccountAttached({required this.accountData});
}

class UserAccountNoAccountInformation extends UserAccountState {}
