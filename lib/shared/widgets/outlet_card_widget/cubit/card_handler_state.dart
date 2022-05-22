part of 'card_handler_cubit.dart';

@immutable
abstract class CardHandlerState {}

class CardHandlerIdleState extends CardHandlerState {
  final int? currentOpenedCard;
  CardHandlerIdleState({this.currentOpenedCard});

  CardHandlerIdleState copyWith({int? open}) {
    return CardHandlerIdleState(currentOpenedCard: open);
  }
}
