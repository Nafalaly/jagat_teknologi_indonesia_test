part of 'outlet_card_widget_bloc.dart';

@immutable
abstract class OutletCardWidgetEvent {}

class OpenPanel extends OutletCardWidgetEvent {}

class ClosePanel extends OutletCardWidgetEvent {}

class AnimationCompleted extends OutletCardWidgetEvent {}

class AnimationStarting extends OutletCardWidgetEvent {}

class AnimationChanges extends OutletCardWidgetEvent {
  final double position;
  AnimationChanges({required this.position});
}
