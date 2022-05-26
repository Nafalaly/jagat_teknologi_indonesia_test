part of '../screens.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  final int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OutletCubit()),
        BlocProvider(create: (context) => CardHandlerCubit()),
        BlocProvider(
            create: (context) => DashboardBloc(
                  connection: context.read<ConnectivityCubit>(),
                  outletCubit: context.read<OutletCubit>(),
                  backgroundService: context.read<BackgroundServiceBloc>(),
                )..add(DashboardInitialReload())),
      ],
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardIdleState) {
            if (state.navigator is DashboardToMasuk) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext _) {
                return IncomeServicePage(
                  currentOutletSub:
                      (state.navigator as DashboardToMasuk).currentOutletSub,
                  availableOutletSub:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .outletSubs,
                  currencies:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .currencies,
                );
              }));
              context
                  .read<DashboardBloc>()
                  .add(DashboardNavigatingToOtherPage());
            } else if (state.navigator is DashboardToKeluar) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext _) {
                return OutcomeServicePage(
                  currentOutletSub:
                      (state.navigator as DashboardToKeluar).currentOutletSub,
                  availableOutletSub:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .outletSubs,
                  currencies:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .currencies,
                );
              }));
              context
                  .read<DashboardBloc>()
                  .add(DashboardNavigatingToOtherPage());
            } else if (state.navigator is DashboardToPindah) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext _) {
                return PindahServicePage(
                  currentOutletSub:
                      (state.navigator as DashboardToPindah).currentOutletSub,
                  availableOutletSub:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .outletSubs,
                  currencies:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .currencies,
                );
              }));
              context
                  .read<DashboardBloc>()
                  .add(DashboardNavigatingToOtherPage());
            } else if (state.navigator is DashboardToMutasi) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext _) {
                return MutasiServicePage(
                  curentOutlet:
                      (state.navigator as DashboardToMutasi).currentOutletSub,
                  availableOutletSub:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .outletSubs,
                  currencies:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .currencies,
                );
              }));
              context
                  .read<DashboardBloc>()
                  .add(DashboardNavigatingToOtherPage());
            } else if (state.navigator is DashboardToKurs) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext _) {
                return KursServicePage(
                  curentOutlet:
                      (state.navigator as DashboardToKurs).currentOutletSub,
                  availableOutletSub:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .outletSubs,
                  currencies:
                      (context.read<OutletCubit>().state as OutletIdleState)
                          .outlet
                          .currencies,
                );
              }));
              context
                  .read<DashboardBloc>()
                  .add(DashboardNavigatingToOtherPage());
            }
          }
        },
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
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/btn_notification.png'),
                    )
                  ],
                ),
                body: Stack(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    bodyDisplay(),
                    appMenus(context),
                    networkIndicator(),
                  ],
                ))),
      ),
    );
  }

  Widget networkIndicator() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardIdleState) {
          if ((state).connectionState is NoInternetConnections) {
            return Positioned(
              bottom: 0,
              child: Container(
                  height: 30,
                  width: DeviceScreen.devWidth,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15))),
                  child: Text('No Internet connection',
                      style: blackFontStyle3.copyWith(color: Colors.white))),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget bodyDisplay() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardIdleState) {
          switch (state.currentIndexMenu) {
            case 0:
              return Container(
                margin: const EdgeInsets.only(top: 80),
                height: DeviceScreen.devHeight,
                width: DeviceScreen.devWidth,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: (state).outlet != null
                    ? ListView(
                        shrinkWrap: true,
                        children: [
                          for (int i = 0;
                              i < (state).outlet!.outletSubs.length;
                              i++)
                            Container(
                              padding: EdgeInsets.only(top: i == 0 ? 20 : 0),
                              child: OutletCardWidget(
                                endPos: 0,
                                dashboard: context.read<DashboardBloc>(),
                                startPos:
                                    (DeviceScreen.devWidth - (80 + 20)) * -1,
                                outletSub: (state).outlet!.outletSubs[i],
                                currencies: state.outlet!.currencies,
                                cardCubit: context.read<CardHandlerCubit>(),
                                index: i,
                              ),
                            )
                        ],
                      )
                    : const SizedBox(),
              );
            default:
              return const Center(
                child: Text('No Services available'),
              );
          }
        } else {
          return const SizedBox();
        }
      },
    );
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
                    child: state.dataStatus is DataReloading
                        ? loadingIndicator
                        : Image.asset('assets/btn_reload.png',
                            fit: BoxFit.cover),
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

    canvas.drawShadow(garis, Colors.black, 2.5, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
