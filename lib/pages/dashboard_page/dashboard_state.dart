// ignore_for_file: must_be_immutable

part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {
  DashboardState();
  int currentIndexMenu = 0;
}

class DashboardInitial extends DashboardState {}

class DashboardIdleState extends DashboardState {
  Outlet? outlet;
  final DataState dataStatus;
  final DashboardNavigator navigator;
  final ConnectivityState connectionState;

  DashboardIdleState({
    int? index = 0,
    this.connectionState = const InternetConnected(),
    this.navigator = const DashboardNavigatorIdle(),
    this.dataStatus = const DataReloading(),
    this.outlet,
  }) {
    super.currentIndexMenu = index!;
    outlet ??= Outlet();
  }
  DashboardState copyWith(
      {int? currentIndex,
      DataState? dataStatus,
      Outlet? outlet,
      ConnectivityState? connectionState,
      DashboardNavigator? navigator}) {
    return DashboardIdleState(
      connectionState: connectionState ?? this.connectionState,
      index: currentIndex ?? currentIndexMenu,
      dataStatus: dataStatus ?? this.dataStatus,
      outlet: outlet ?? this.outlet,
      navigator: navigator ?? this.navigator,
    );
  }
}

abstract class DataState {
  const DataState();
}

class DataReloading extends DataState {
  const DataReloading();
}

class DataInteruptedByNetworkProblem extends DataState {
  const DataInteruptedByNetworkProblem();
}

class DataLoaded extends DataState {
  const DataLoaded();
}
