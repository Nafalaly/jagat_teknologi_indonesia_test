part of 'services.dart';

class DeviceScreen {
  static late double _width;
  static late double _height;
  late BuildContext context;

  DeviceScreen.setup({required context}) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top);
  }

  static double get devHeight => _height;
  static double get devWidth => _width;
}
