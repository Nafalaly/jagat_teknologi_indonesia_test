part of 'outlet_card_widget_bloc.dart';

@immutable
abstract class OutletCardWidgetState {}

class OutletCardWidgetIdleState extends OutletCardWidgetState {
  final bool panelStateOpen;
  final AnimationState animationState;
  final int index;
  final double animXpos;
  OutletCardWidgetIdleState(
      {this.panelStateOpen = false,
      required this.index,
      this.animationState = const PanelAnimationIdle(),
      required this.animXpos});

  OutletCardWidgetIdleState copyWith(
      {bool? panelStateOpen,
      double? animXpos,
      AnimationState? animationState}) {
    return OutletCardWidgetIdleState(
      panelStateOpen: panelStateOpen ?? this.panelStateOpen,
      animationState: animationState ?? this.animationState,
      index: index,
      animXpos: animXpos ?? this.animXpos,
    );
  }
}

abstract class AnimationState {
  const AnimationState();
}

class PanelAnimationInProgress extends AnimationState {
  const PanelAnimationInProgress();
}

class PanelAnimationIdle extends AnimationState {
  const PanelAnimationIdle();
}
