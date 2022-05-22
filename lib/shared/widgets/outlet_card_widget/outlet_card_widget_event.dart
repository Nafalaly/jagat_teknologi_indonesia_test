part of 'outlet_card_widget_bloc.dart';

@immutable
abstract class OutletCardWidgetEvent {}

class OpenPanel extends OutletCardWidgetEvent {}

class ClosePanel extends OutletCardWidgetEvent {}
