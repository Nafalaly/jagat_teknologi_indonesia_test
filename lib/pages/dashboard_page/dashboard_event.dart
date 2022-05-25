part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {
  const DashboardEvent();
}

class DashboardReloadData extends DashboardEvent {}

class DashboardInitialReload extends DashboardEvent {}

class DashboardReloadComplete extends DashboardEvent {
  final Outlet outlet;
  const DashboardReloadComplete({required this.outlet});
}

class DashboardNoConnection extends DashboardEvent {
  const DashboardNoConnection();
}

class DashboardConnectionEstablished extends DashboardEvent {
  const DashboardConnectionEstablished();
}

class DashboardReloadCompleteNoData extends DashboardEvent {}

class DashboardNavigatingToOtherPage extends DashboardEvent {}

class DashboardNavigateToMasuk extends DashboardEvent {
  final OutletSub currentOutletSub;
  const DashboardNavigateToMasuk({required this.currentOutletSub});
}

class DashboardNavigateToKeluar extends DashboardEvent {
  final OutletSub currentOutletSub;
  const DashboardNavigateToKeluar({required this.currentOutletSub});
}

class DashboardNavigateToPindah extends DashboardEvent {
  final OutletSub currentOutletSub;
  const DashboardNavigateToPindah({required this.currentOutletSub});
}

class DashboardSwitchToMenu extends DashboardEvent {
  final int switchToIndex;
  const DashboardSwitchToMenu({required this.switchToIndex});
}

class DashboardReloadFailed extends DashboardEvent {
  const DashboardReloadFailed();
}
