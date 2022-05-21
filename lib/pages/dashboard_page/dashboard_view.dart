part of '../screens.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  final int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(DashboardInitialReload()),
      child: SafeArea(
          child: Scaffold(
              backgroundColor: mainColor,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'APP KEUANGAN',
                  style: blackFontStyle.copyWith(
                      color: mainColor, fontWeight: FontWeight.w700),
                ),
                actions: [
                  SizedBox(
                    height: 30,
                    width: 60,
                    child: Image.asset('assets/btn_notification.png'),
                  )
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [appMenus(context), bodyDisplay()],
              ))),
    );
  }

  Widget bodyDisplay() {
    return Container(
        height: DeviceScreen.devHeight - 180,
        width: DeviceScreen.devWidth,
        color: Colors.red);
  }

  Widget appMenus(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardIdleState) {
          return Column(children: [
            Container(
              height: 80,
              width: DeviceScreen.devWidth,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    4,
                    (index) => menuWidget(
                        context: context,
                        index: index,
                        currentIndex: state.currentIndexMenu)),
              ),
            ),
            CustomPaint(
              painter: BoxShadowPainter(),
              child: ClipPath(
                clipper: MyCustomClipper(),
                child: GestureDetector(
                  onTap: () =>
                      context.read<DashboardBloc>().add(DashboardReloadData()),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    height: 40,
                    width: 85,
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    alignment: Alignment.topCenter,
                    child: state.dataStatus is DataLoaded
                        ? Image.asset('assets/btn_reload.png',
                            fit: BoxFit.cover)
                        : loadingIndicator,
                  ),
                ),
              ),
            )
          ]);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget menuWidget(
      {required int index,
      required int currentIndex,
      required BuildContext context}) {
    late String img, text;
    switch (index) {
      case 0:
        text = 'Home';
        if (index == currentIndex) {
          img = 'assets/btn_home.png';
        } else {
          img = 'assets/btn_home_inactive.png';
        }
        break;
      case 1:
        text = 'Transaksi';
        if (index == currentIndex) {
          img = 'assets/btn_transaction.png';
        } else {
          img = 'assets/btn_transaction_inactive.png';
        }
        break;
      case 2:
        text = 'Laporan';
        if (index == currentIndex) {
          img = 'assets/btn_report.png';
        } else {
          img = 'assets/btn_report_inactive.png';
        }
        break;
      case 3:
        text = 'Tools';
        if (index == currentIndex) {
          img = 'assets/btn_tools.png';
        } else {
          img = 'assets/btn_tools_inactive.png';
        }
        break;
    }
    return GestureDetector(
      onTap: () => context
          .read<DashboardBloc>()
          .add(DashboardSwitchToMenu(switchToIndex: index)),
      child: Container(
        width: DeviceScreen.devWidth / 4,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(img, fit: BoxFit.cover),
            ),
            Text(text,
                style: blackFontStyle2.copyWith(
                    color: index == currentIndex ? mainColor : greyColor))
          ],
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  double value = 10;
  @override
  Path getClip(Size size) {
    Path garis = Path();
    garis.quadraticBezierTo(
        value, size.height * 0.15, value, size.height * 0.35);
    garis.lineTo(value, size.height * 0.6);
    garis.quadraticBezierTo(
        value, size.height * 0.95, (value * 2) + 10, size.height);
    garis.lineTo(size.width - ((value * 2) + 10), size.height);

    garis.quadraticBezierTo(size.width - value, size.height * 0.95,
        size.width - value, size.height * 0.6);
    garis.lineTo(size.width - value, size.height * 0.35);
    garis.quadraticBezierTo(
        size.width - value, size.height * 0.15, size.width, 0);
    garis.close();
    return garis;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double value = 10;
    Path garis = Path();
    garis.quadraticBezierTo(
        value, size.height * 0.15, value, size.height * 0.35);
    garis.lineTo(value, size.height * 0.6);
    garis.quadraticBezierTo(
        value, size.height * 0.95, (value * 2) + 10, size.height);
    garis.lineTo(size.width - ((value * 2) + 10), size.height);

    garis.quadraticBezierTo(size.width - value, size.height * 0.95,
        size.width - value, size.height * 0.6);
    garis.lineTo(size.width - value, size.height * 0.35);
    garis.quadraticBezierTo(
        size.width - value, size.height * 0.15, size.width, 0);
    garis.close();

    canvas.drawShadow(garis, Colors.black, 5.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
