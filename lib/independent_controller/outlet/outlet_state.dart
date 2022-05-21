part of 'outlet_cubit.dart';

@immutable
abstract class OutletState {
  const OutletState();
}

class OutletInitial extends OutletState {}

class OutletNoData extends OutletState {}

class OutletErrorOccurred extends OutletState {}

class OutletIdleState extends OutletState {
  final Outlet outlet;
  const OutletIdleState({
    required this.outlet,
  });
}
