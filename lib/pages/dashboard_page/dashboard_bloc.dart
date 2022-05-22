// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/independent_controller/outlet/outlet_cubit.dart';
import 'package:jagat_teknologi_indonesia_test/models/models.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required this.outletCubit}) : super(DashboardInitial()) {
    on(mapEvent);
  }
  APIOutlet apiOutlet = APIOutlet();
  OutletCubit outletCubit;

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
          dataStatus: const DataReload(),
          currentIndex: state.currentIndexMenu));
      dummyFetch();
    } else if (event is DashboardReloadCompleteNoData) {
      emit(DashboardIdleState(index: state.currentIndexMenu));
    } else if (event is DashboardNavigatingToOtherPage) {
      emit((state as DashboardIdleState)
          .copyWith(navigator: DashboardNavigator.idle));
    } else if (event is DashboardNavigateToMasuk) {
      emit((state as DashboardIdleState)
          .copyWith(navigator: DashboardNavigator.masuk));
    }
  }

  void loadInitialData() async {
    dummyFetch();
  }

  void dummyFetch() async {
    ResponseParser result = await apiOutlet.fetchInitialData();
    Outlet outlet;
    try {
      if (result.getStatus == ResponseStatus.success) {
        outlet = Outlet.fromJson(apiData: result.getData!);
        outletCubit.setData(outlet: outlet);
        add(DashboardReloadComplete(outlet: outlet));
      } else {
        outletCubit.setNodata();
        add(DashboardReloadCompleteNoData());
      }
    } on Exception {
      outletCubit.setError();
      add(DashboardReloadCompleteNoData());
    }
  }
}
