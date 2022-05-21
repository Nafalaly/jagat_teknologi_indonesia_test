part of 'splash_bloc.dart';

@immutable
abstract class SplashScreenState {
  const SplashScreenState();
}

class SplashScreenInitial extends SplashScreenState {}

class SplashScreenLoadingState extends SplashScreenState {}

class SplashScreenLoadProcessComplete extends SplashScreenState {
  final bool hasAccount;
  const SplashScreenLoadProcessComplete({required this.hasAccount});
}
