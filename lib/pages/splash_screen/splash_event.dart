part of 'splash_bloc.dart';

@immutable
abstract class SplashScreenEvent {}

class SplashScreenLoadData extends SplashScreenEvent {}

class SplashScreenAccountLoaded extends SplashScreenEvent {}

class SplashScreenNoAccountLoaded extends SplashScreenEvent {}
