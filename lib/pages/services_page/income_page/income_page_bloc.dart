import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'income_page_event.dart';
part 'income_page_state.dart';

class IncomePageBloc extends Bloc<IncomePageEvent, IncomePageState> {
  IncomePageBloc() : super(IncomePageInitial()) {
    on<IncomePageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
