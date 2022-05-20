part of 'shared.dart';

//Color greyColor = "8D82A3".toColor();
Color greyColor = "9fa8b5".toColor();
Color mainColor = "#2787BD".toColor();
Color secondColor = "#1e2087".toColor();
Color thirdColor = "#dad5c0".toColor();
Color greyBackground = "F0F0F0".toColor();
String iconWtText = "icon_w_text.png";
String logoOnly = "assets/logo.jpg";
String accountBorder = "assets/photo_border.png";

Widget loadingIndicator = SpinKitFadingCircle(
  size: 45,
  color: mainColor,
);
Widget loadingIndicator2 = SpinKitWave(
  size: 15,
  color: mainColor,
);

TextStyle greyFontStyle = GoogleFonts.poppins().copyWith(color: greyColor);
TextStyle blackFontStyle = GoogleFonts.poppins()
    .copyWith(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500);
TextStyle blackFontStyle2 = GoogleFonts.poppins()
    .copyWith(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
TextStyle blackFontStyle3 = GoogleFonts.poppins().copyWith(color: Colors.black);

TextStyle headerFontStyle = GoogleFonts.poppins()
    .copyWith(color: Colors.black, fontSize: 50, fontWeight: FontWeight.w500);
TextStyle headerFontStyle2 = GoogleFonts.poppins()
    .copyWith(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w500);

const double defaultMargin = 24;
const double defaultBottombarHeight = 65;

String priceFormat(double format) {
  return NumberFormat.currency(
          locale: 'id-ID', symbol: 'IDR ', decimalDigits: 0)
      .format(format);
}

String dateFormat(DateTime time) {
  return DateFormat.yMMMMd('en_US').format(time);
}

String dateFormatMonthYearOnly(DateTime time) {
  return '${DateFormat.MMMM('en_US').format(time)} ${DateFormat.y('en_US').format(time)}';
}

void showWarning(
    {required String message,
    required context,
    Color? color,
    required Function onFinish}) async {
  final snackBar = SnackBar(
    backgroundColor: color ?? Colors.deepOrange,
    content: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.white),
        Container(
          padding: const EdgeInsets.only(left: 10),
          width: DeviceScreen.devWidth - 100,
          child: Text(
            message,
            style: blackFontStyle2.copyWith(color: Colors.white),
            maxLines: 2,
          ),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  onFinish();
}

class ClipShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path garis = Path();
    garis.lineTo(0, size.height * 0.8);
    garis.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.8);
    garis.lineTo(size.width, 0);
    garis.close();
    return garis;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
