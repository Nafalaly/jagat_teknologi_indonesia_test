// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:jagat_teknologi_indonesia_test/shared/widgets/outlet_card_widget/cubit/card_handler_cubit.dart';
import 'package:meta/meta.dart';

part 'outlet_card_widget_event.dart';
part 'outlet_card_widget_state.dart';

class OutletCardWidgetBloc
    extends Bloc<OutletCardWidgetEvent, OutletCardWidgetState> {
  OutletCardWidgetBloc(
      {required this.cardHandlerCubit, required this.cardIndex})
      : super(OutletCardWidgetIdleState(index: cardIndex)) {
    cardListener = cardHandlerCubit.stream.listen((changes) {
      if (changes is CardHandlerIdleState) {
        if (changes.currentOpenedCard != null) {
          if (changes.currentOpenedCard !=
                  (state as OutletCardWidgetIdleState).index &&
              (state as OutletCardWidgetIdleState).detailOpen) {
            add(ClosePanel());
          }
        }
      }
    });
    on(mapEvent);
  }
  int cardIndex;
  CardHandlerCubit cardHandlerCubit;
  late StreamSubscription cardListener;

  Future<void> mapEvent(
      OutletCardWidgetEvent event, Emitter<OutletCardWidgetState> emit) async {
    if (event is OpenPanel) {
      cardHandlerCubit.openACard(cardIndex: cardIndex);
      emit((state as OutletCardWidgetIdleState).copyWith(detailOpen: true));
    } else if (event is ClosePanel) {
      if ((cardHandlerCubit.state as CardHandlerIdleState).currentOpenedCard ==
          cardIndex) {
        cardHandlerCubit.closeCard();
      }
      emit((state as OutletCardWidgetIdleState).copyWith(detailOpen: false));
    }
  }

  @override
  Future<void> close() {
    cardListener.cancel();
    return super.close();
  }
}
