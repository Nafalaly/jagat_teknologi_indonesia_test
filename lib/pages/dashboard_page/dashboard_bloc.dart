import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on(mapEvent);
  }

  Future<void> mapEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    if (event is DashboardInitialReload) {
      emit(DashboardIdleState());
      loadData();
      // dummyFetch();
    } else if (event is DashboardReloadComplete) {
      emit(DashboardIdleState(dataStatus: const DataLoaded()));
    } else if (event is DashboardSwitchToMenu) {
      emit((state as DashboardIdleState)
          .copyWith(currentIndex: event.switchToIndex));
    } else if (event is DashboardReloadData) {
      emit((state as DashboardIdleState)
          .copyWith(dataStatus: const DataReload()));
      dummyFetch();
    }
  }

  void loadData() {
    add(DashboardReloadComplete());
  }

  void dummyFetch() async {
    await Future.delayed(const Duration(seconds: 5));
    add(DashboardReloadComplete());
  }
}
