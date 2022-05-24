part of 'dashboard_bloc.dart';

abstract class DashboardNavigator {
  const DashboardNavigator();
}

class DashboardNavigatorIdle extends DashboardNavigator {
  const DashboardNavigatorIdle();
}

class DashboardToMasuk extends DashboardNavigator {
  final OutletSub currentOutletSub;
  DashboardToMasuk({required this.currentOutletSub});
}

class DashboardToKeluar extends DashboardNavigator {
  final OutletSub currentOutletSub;
  DashboardToKeluar({required this.currentOutletSub});
}
