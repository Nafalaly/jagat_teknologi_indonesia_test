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

class DashboardToPindah extends DashboardNavigator {
  final OutletSub currentOutletSub;
  DashboardToPindah({required this.currentOutletSub});
}

class DashboardToKurs extends DashboardNavigator {
  final OutletSub currentOutletSub;
  DashboardToKurs({required this.currentOutletSub});
}

class DashboardToMutasi extends DashboardNavigator {
  final OutletSub currentOutletSub;
  DashboardToMutasi({required this.currentOutletSub});
}
