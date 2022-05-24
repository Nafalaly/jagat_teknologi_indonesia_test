// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/background_service/background_service_bloc.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/outlet/outlet_cubit.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_navigator.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required this.outletCubit,
    required this.backgroundService,
    required this.connection,
  }) : super(DashboardInitial()) {
    connectionMonitor = connection.stream.listen((event) {
      if (event is InternetConnected) {
        add(const DashboardConnectionEstablished());
      } else {
        add(const DashboardNoConnection());
      }
    });
    on(mapEvent);
  }
  APIOutlet apiOutlet = APIOutlet();
  OutletCubit outletCubit;
  BackgroundServiceBloc backgroundService;
  ConnectivityCubit connection;
  late StreamSubscription connectionMonitor;

  Future<void> mapEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    if (event is DashboardInitialReload) {
      emit(DashboardIdleState());
      loadInitialData();
    } else if (event is DashboardReloadComplete) {
      emit(DashboardIdleState(
          dataStatus: const DataLoaded(),
          outlet: event.outlet,
          index: state.currentIndexMenu));
    } else if (event is DashboardSwitchToMenu) {
      emit((state as DashboardIdleState)
          .copyWith(currentIndex: event.switchToIndex));
    } else if (event is DashboardReloadData) {
      emit((state as DashboardIdleState).copyWith(
          dataStatus: const DataReloading(),
          currentIndex: state.currentIndexMenu));
      fetchOutletData();
    } else if (event is DashboardReloadCompleteNoData) {
      emit(DashboardIdleState(index: state.currentIndexMenu));
    } else if (event is DashboardNavigatingToOtherPage) {
      emit((state as DashboardIdleState)
          .copyWith(navigator: const DashboardNavigatorIdle()));
    } else if (event is DashboardNavigateToMasuk) {
      emit((state as DashboardIdleState).copyWith(
          navigator:
              DashboardToMasuk(currentOutletSub: event.currentOutletSub)));
    } else if (event is DashboardNavigateToKeluar) {
      emit((state as DashboardIdleState).copyWith(
          navigator:
              DashboardToKeluar(currentOutletSub: event.currentOutletSub)));
    } else if (event is DashboardNoConnection) {
      emit((state as DashboardIdleState)
          .copyWith(connectionState: const NoInternetConnections()));
    } else if (event is DashboardConnectionEstablished) {
      emit((state as DashboardIdleState)
          .copyWith(connectionState: const InternetConnected()));
    } else if (event is DashboardReloadFailed) {
      emit((state as DashboardIdleState)
          .copyWith(dataStatus: const DataInteruptedByNetworkProblem()));
    }
  }

  void loadInitialData() async {
    fetchOutletData();
  }

  void fetchOutletData() async {
    if ((state as DashboardIdleState).connectionState
            is NoInternetConnections ||
        connection.state is NoInternetConnections) {
      add(const DashboardReloadFailed());
      return;
    }
    try {
      ResponseParser result = await apiOutlet.fetchInitialData();
      Outlet outlet;
      if (result.getStatus == ResponseStatus.success) {
        outlet = Outlet.fromJson(apiData: result.getData!);
        outletCubit.setData(outlet: outlet);
        add(DashboardReloadComplete(outlet: outlet));
      } else if (result.getStatusCode == 501) {
        add(const DashboardReloadFailed());
      } else {
        outletCubit.setNodata();
        add(DashboardReloadCompleteNoData());
      }
    } on Exception {
      outletCubit.setError();
      add(const DashboardReloadFailed());
    }
  }

  @override
  Future<void> close() {
    connectionMonitor.cancel();
    return super.close();
  }
}
