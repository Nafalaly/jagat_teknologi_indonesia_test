// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'card_handler_state.dart';

class CardHandlerCubit extends Cubit<CardHandlerState> {
  CardHandlerCubit() : super(CardHandlerIdleState());

  void openACard({required int cardIndex}) {
    emit((state as CardHandlerIdleState).copyWith(open: cardIndex));
  }

  void closeCard() {
    emit((state as CardHandlerIdleState).copyWith(open: null));
  }
}
