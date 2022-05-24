part of 'background_service_bloc.dart';

@immutable
abstract class BackgroundServiceEvent {
  const BackgroundServiceEvent();
}

class BackgroundServiceInitiateServiceStart extends BackgroundServiceEvent {
  const BackgroundServiceInitiateServiceStart();
}

class BackgroundServiceStartProcess extends BackgroundServiceEvent {
  const BackgroundServiceStartProcess();
}

class BackgroundServiceStopProcess extends BackgroundServiceEvent {
  const BackgroundServiceStopProcess();
}

class BackgroundServiceConnectionEstablished extends BackgroundServiceEvent {
  const BackgroundServiceConnectionEstablished();
}

class BackgroundServiceConnectionInterruptsProcess
    extends BackgroundServiceEvent {
  const BackgroundServiceConnectionInterruptsProcess();
}

class BackgroundServiceUserLoggedOut extends BackgroundServiceEvent {
  const BackgroundServiceUserLoggedOut();
}

class BackgroundServiceUserLoggedIn extends BackgroundServiceEvent {
  const BackgroundServiceUserLoggedIn();
}

class BackgroundServiceStatusChange extends BackgroundServiceEvent {
  final bool isReady;
  const BackgroundServiceStatusChange({required this.isReady});
}
