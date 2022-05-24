part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class DashboardReloadData extends DashboardEvent {}

class DashboardInitialReload extends DashboardEvent {}

class DashboardReloadComplete extends DashboardEvent {
  final Outlet outlet;
  DashboardReloadComplete({required this.outlet});
}

class DashboardReloadCompleteNoData extends DashboardEvent {}

class DashboardNavigatingToOtherPage extends DashboardEvent {}

class DashboardNavigateToMasuk extends DashboardEvent {
  final OutletSub currentOutletSub;
  DashboardNavigateToMasuk({required this.currentOutletSub});
}

class DashboardNavigateToKeluar extends DashboardEvent {
  final OutletSub currentOutletSub;
  DashboardNavigateToKeluar({required this.currentOutletSub});
}

class DashboardSwitchToMenu extends DashboardEvent {
  final int switchToIndex;
  DashboardSwitchToMenu({required this.switchToIndex});
}
