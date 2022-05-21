part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardIdleState extends DashboardState {
  final int currentIndexMenu;
  final DataState dataStatus;

  DashboardIdleState(
      {this.currentIndexMenu = 0, this.dataStatus = const DataReload()});
  DashboardState copyWith({int? currentIndex, DataState? dataStatus}) {
    return DashboardIdleState(
      currentIndexMenu: currentIndex ?? currentIndexMenu,
      dataStatus: dataStatus ?? this.dataStatus,
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
