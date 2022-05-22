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

  DashboardIdleState({
    int? index = 0,
    this.dataStatus = const DataReload(),
    this.outlet,
  }) {
    super.currentIndexMenu = index!;
    outlet ??= Outlet();
  }
  DashboardState copyWith(
      {int? currentIndex, DataState? dataStatus, Outlet? outlet}) {
    return DashboardIdleState(
      index: currentIndex ?? currentIndexMenu,
      dataStatus: dataStatus ?? this.dataStatus,
      outlet: outlet ?? this.outlet,
    );
  }
}

abstract class DataState {
  const DataState();
}

class DataReload extends DataState {
  const DataReload();
}

class DataLoaded extends DataState {
  const DataLoaded();
}
