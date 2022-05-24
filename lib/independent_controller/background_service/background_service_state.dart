part of 'background_service_bloc.dart';

@immutable
abstract class BackgroundServiceState {}

class BackgroundServiceInitial extends BackgroundServiceState {}

class BackgroundServiceReady extends BackgroundServiceState {}

class BackgroundServiceRunningState extends BackgroundServiceState {}

class BackgroundServiceIdleState extends BackgroundServiceState {}

class BackgroundServiceStoppedState extends BackgroundServiceState {}
