part of 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({required this.internetAdaptor})
      : super(const InternetInitial()) {
    connectivityStream = internetAdaptor.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        emitInternetConnected();
      } else {
        emitInternetDisconnected();
      }
    });
  }

  final Connectivity internetAdaptor;
  late StreamSubscription connectivityStream;

  void emitInternetConnected() => emit(const InternetConnected());

  void emitInternetDisconnected() => emit(const NoInternetConnections());

  @override
  Future<void> close() {
    connectivityStream.cancel();
    return super.close();
  }
}
