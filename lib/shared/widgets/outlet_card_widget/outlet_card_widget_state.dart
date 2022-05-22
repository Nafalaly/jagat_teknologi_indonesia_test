part of 'outlet_card_widget_bloc.dart';

@immutable
abstract class OutletCardWidgetState {}

class OutletCardWidgetIdleState extends OutletCardWidgetState {
  final bool detailOpen;
  final int index;
  OutletCardWidgetIdleState({this.detailOpen = false, required this.index});

  OutletCardWidgetIdleState copyWith({bool? detailOpen}) {
    return OutletCardWidgetIdleState(
        detailOpen: detailOpen ?? this.detailOpen, index: index);
  }
}
