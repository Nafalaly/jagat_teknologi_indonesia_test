part of '../../shared.dart';

class OutletCardWidget extends StatefulWidget {
  const OutletCardWidget({
    Key? key,
    required this.outletSub,
    required this.currencies,
    required this.index,
    required this.dashboard,
    required this.cardCubit,
    required this.startPos,
    required this.endPos,
  }) : super(key: key);
  final OutletSub outletSub;
  final int index;
  final double startPos;
  final double endPos;
  final List<Currency> currencies;
  final DashboardBloc dashboard;
  final CardHandlerCubit cardCubit;

  @override
  State<OutletCardWidget> createState() => _OutletCardWidgetState();
}

class _OutletCardWidgetState extends State<OutletCardWidget>
    with SingleTickerProviderStateMixin {
  final double widgetHeight = 160;
  late AnimationController controller;
  late Animation positionAnimation;
  late OutletCardWidgetBloc outletBloc;

  @override
  void initState() {
    super.initState();
    outletBloc = OutletCardWidgetBloc(
        dashboard: widget.dashboard,
        cardHandlerCubit: widget.cardCubit,
        cardIndex: widget.index,
        initialAnimPos: widget.startPos);
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        outletBloc.add(AnimationChanges(position: positionAnimation.value));
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          outletBloc.add(AnimationCompleted());
        }
      });
    positionAnimation = Tween<double>(
            begin: widget.startPos, end: widget.endPos)
        .animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => outletBloc,
      child: BlocBuilder<OutletCardWidgetBloc, OutletCardWidgetState>(
        builder: (context, state) {
          return BlocListener<OutletCardWidgetBloc, OutletCardWidgetState>(
            listener: (context, state) {
              if ((state as OutletCardWidgetIdleState).panelStateOpen &&
                  state.animationState is PanelAnimationIdle) {
                controller.forward();
                context.read<OutletCardWidgetBloc>().add(AnimationStarting());
              } else if (!(state).panelStateOpen &&
                  state.animationState is PanelAnimationIdle) {
                controller.reverse();
                context.read<OutletCardWidgetBloc>().add(AnimationStarting());
              }
            },
            child: Container(
              height: widgetHeight,
              width: DeviceScreen.devWidth,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    outletDisplay(),
                    (state as OutletCardWidgetIdleState).panelStateOpen
                        ? GestureDetector(
                            onTap: () => context
                                .read<OutletCardWidgetBloc>()
                                .add(ClosePanel()),
                            child: Container(
                              height: widgetHeight,
                              width: DeviceScreen.devWidth,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          )
                        : const SizedBox(),
                    detailOutletDisplay(),
                    (state).panelStateOpen
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () => context
                                .read<OutletCardWidgetBloc>()
                                .add(OpenPanel()),
                            child: Container(
                                height: widgetHeight,
                                width: 50,
                                color: Colors.transparent)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget detailOutletDisplay() {
    const double upperCompHeight = 50;
    final List<_ButtonService> services = [
      _ButtonService(
          title: 'Masuk',
          assetPath: 'assets/btn_income.png',
          onTap: () {
            widget.dashboard.add(
                DashboardNavigateToMasuk(currentOutletSub: widget.outletSub));
          }),
      _ButtonService(
          title: 'Keluar',
          assetPath: 'assets/btn_outcome.png',
          onTap: () {
            widget.dashboard.add(
                DashboardNavigateToKeluar(currentOutletSub: widget.outletSub));
          }),
      _ButtonService(
          title: 'Pindah',
          assetPath: 'assets/btn_move.png',
          onTap: () {
            widget.dashboard.add(
                DashboardNavigateToPindah(currentOutletSub: widget.outletSub));
          }),
      _ButtonService(
          title: 'Mutasi',
          assetPath: 'assets/btn_history.png',
          onTap: () {
            widget.dashboard.add(
                DashboardNavigateToMutasi(currentOutletSub: widget.outletSub));
          }),
      _ButtonService(
          title: 'Kurs',
          assetPath: 'assets/btn_kurs.png',
          onTap: () {
            widget.dashboard.add(
                DashboardNavigateToKurs(currentOutletSub: widget.outletSub));
          }),
    ];
    return BlocBuilder<OutletCardWidgetBloc, OutletCardWidgetState>(
      builder: (context, state) {
        return Positioned(
          right: (state as OutletCardWidgetIdleState).animXpos,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myWidget(),
              Container(
                height: widgetHeight,
                width: DeviceScreen.devWidth - (20 + 60),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: secondColor,
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     spreadRadius: 1,
                  //     blurRadius: 4,
                  //     offset: Offset(-3, 0),
                  //   ),
                  // ],
                ),
                child: (state).panelStateOpen
                    ? Column(
                        children: [
                          SizedBox(
                            height: upperCompHeight,
                            width: DeviceScreen.devWidth - (20 + 60),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: services
                                    .map((service) =>
                                        serviceWidget(service: service))
                                    .toList()),
                          ),
                          Container(
                            height: widgetHeight - (upperCompHeight + 30),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            width: DeviceScreen.devWidth - (20 + 60),
                            child: Column(
                              children: [
                                detailTextInformationWidget(
                                    trailingText: '16',
                                    leaderText: 'Jumlah Barang',
                                    isHeader: true),
                                Column(
                                    children: widget.currencies
                                        .map((e) => detailTextInformationWidget(
                                            trailingText: dummyValue(e),
                                            leaderText: e.currencyName))
                                        .toList())
                              ],
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  String dummyValue(Currency currency) {
    switch (currency.currencyName) {
      case 'IDR':
        return priceFormat(format: 100000000, symbol: currency.currencyLogo);
      case 'USD':
        return priceFormat(format: 2000, symbol: currency.currencyLogo);
      case 'EUR':
        return priceFormat(format: 200, symbol: currency.currencyLogo);
      case 'SGD':
        return priceFormat(format: 1000, symbol: currency.currencyLogo);
      default:
        return 'This is an dummy value only';
    }
  }

  Widget detailTextInformationWidget(
      {required String leaderText,
      required String trailingText,
      bool? isHeader = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomPaint(
            painter: DashedLinePainter(),
            child: SizedBox(
              height: 0.5,
              width: DeviceScreen.devWidth - (20 + 60),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 15,
          width: DeviceScreen.devWidth - (20 + 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(leaderText,
                    style: greyFontStyle.copyWith(
                        fontWeight:
                            isHeader! ? FontWeight.bold : FontWeight.w400)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                color: Colors.white,
                child: Text(trailingText,
                    style: greyFontStyle.copyWith(
                        fontWeight:
                            isHeader ? FontWeight.bold : FontWeight.w400)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget serviceWidget({
    required _ButtonService service,
  }) {
    return GestureDetector(
      onTap: () => service.onTap(),
      child: SizedBox(
        height: 50,
        width: 50,
        child: Column(children: [
          SizedBox(
            height: 31,
            width: 50,
            child: Image.asset(
              service.assetPath,
              fit: BoxFit.scaleDown,
            ),
          ),
          Text(
            service.title,
            style: blackFontStyle2.copyWith(color: mainColor),
          )
        ]),
      ),
    );
  }

  Widget myWidget() {
    return BlocBuilder<OutletCardWidgetBloc, OutletCardWidgetState>(
      builder: (context, state) {
        return Transform.scale(
          scale: 0.6,
          alignment: Alignment.centerRight,
          child: RotatedBox(
            quarterTurns: 1,
            child: CustomPaint(
              painter: BoxShadowPainter(),
              child: ClipPath(
                clipper: MyCustomClipper(),
                child: GestureDetector(
                  onTap: () {
                    if ((context.read<OutletCardWidgetBloc>().state
                            as OutletCardWidgetIdleState)
                        .panelStateOpen) {
                      context.read<OutletCardWidgetBloc>().add(ClosePanel());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: secondColor,
                    ),
                    height: 40,
                    width: 85,
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                    alignment: Alignment.topCenter,
                    child: Icon(
                        (state as OutletCardWidgetIdleState).panelStateOpen
                            ? Icons.arrow_circle_up_outlined
                            : Icons.add_circle_outline_outlined,
                        color: mainColor,
                        size: 35),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget outletDisplay() {
    return Container(
      height: widgetHeight,
      width: DeviceScreen.devWidth,
      // color: Colors.yellow,
      padding: const EdgeInsets.only(left: 15, top: 10, right: 50, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.outletSub.outletName,
            style: blackFontStyle2.copyWith(
                color: mainColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 7),
          Column(
              children: widget.currencies
                  .map((e) => currencyWidget(symbol: e.currencyName))
                  .toList())
        ],
      ),
    );
  }

  Widget currencyWidget({required String symbol}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: 20,
      width: DeviceScreen.devWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FaIcon(
                  FontAwesomeIcons.moneyBill,
                  color: mainColor,
                  size: 20,
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(symbol,
                      style: blackFontStyle2.copyWith(color: greyColor)),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomPaint(
                painter: DashedLinePainter(),
                child: SizedBox(
                  height: 6,
                  width: DeviceScreen.devWidth - 145,
                ),
              ),
              Container(
                height: 30,
                color: Colors.white,
                alignment: Alignment.centerRight,
                child: Text(_getDummyValueForCurrencies(symbol),
                    style: blackFontStyle2.copyWith(
                        color: mainColor, fontWeight: FontWeight.w600)),
              )
            ],
          )
        ],
      ),
    );
  }
}

String _getDummyValueForCurrencies(String symbol) {
  switch (symbol) {
    case 'IDR':
      return '500.000';
    case 'USD':
      return '0';
    case 'EUR':
      return '20.000';
    case 'SGD':
      return '6.000';
    default:
      return 'This is only dummy value';
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ButtonService {
  String title;
  String assetPath;
  Function onTap;
  _ButtonService({
    required this.title,
    required this.assetPath,
    required this.onTap,
  });
}
