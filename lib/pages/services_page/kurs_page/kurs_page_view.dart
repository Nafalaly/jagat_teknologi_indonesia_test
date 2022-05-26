// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously

part of '../../screens.dart';

class KursServicePage extends StatelessWidget {
  KursServicePage({
    Key? key,
    required this.currencies,
    required this.availableOutletSub,
    required this.curentOutlet,
  }) : super(key: key);
  final List<Currency> currencies;
  final GlobalKey _outlet = GlobalKey(debugLabel: 'outlet');
  final GlobalKey _calculator = GlobalKey(debugLabel: 'calculator');
  final GlobalKey _valueTextField = GlobalKey(debugLabel: 'value key');
  final GlobalKey _valueTextField2 = GlobalKey(debugLabel: 'value key2');
  final GlobalKey _symbolCurrency = GlobalKey(debugLabel: 'symbol1');
  final List<OutletSub> availableOutletSub;
  final OutletSub curentOutlet;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController valueController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KursPageBloc(
          current:
              (context.read<UserAccountCubit>().state as UserAccountAttached)
                  .accountData,
          availableCurrencies: currencies,
          connection: context.read<ConnectivityCubit>(),
          availableOutletSub: availableOutletSub,
          currentOutletSub: curentOutlet),
      child: BlocBuilder<KursPageBloc, KursPageState>(
        builder: (context, state) {
          if (state is KursPageIdleState) {
            return BlocListener<KursPageBloc, KursPageState>(
              listener: (context, state) async {
                if (state is KursPageIdleState) {
                  valueController2.text = state.outputValue.toString();
                }
                if ((state as KursPageIdleState).inputState
                    is KursFormInteruptedByConnection) {
                  showWarning(
                      message: 'Tidak terhubung ke Internet',
                      color: Colors.black,
                      context: context,
                      onFinish: () {
                        context
                            .read<KursPageBloc>()
                            .add(KursConnectionWarningDismiss());
                      });
                }
                if (state.inputState is KursFormBadInputState) {
                  switch ((state.inputState as KursFormBadInputState)
                      .badInputCode) {
                    case 501:
                      badInputFocus(
                          context: context,
                          icon: Icons.store,
                          widgetTarget: _outlet,
                          message: (state.inputState as KursFormBadInputState)
                              .message);
                      break;
                    case 502:
                      badInputFocus(
                          context: context,
                          icon: Icons.money_outlined,
                          widgetTarget: _valueTextField,
                          message: (state.inputState as KursFormBadInputState)
                              .message);
                      break;
                    case 503:
                      badInputFocus(
                          context: context,
                          icon: Icons.attach_money,
                          widgetTarget: _symbolCurrency,
                          message: (state.inputState as KursFormBadInputState)
                              .message);
                      break;
                    case 504:
                      badInputFocus(
                          context: context,
                          icon: Icons.calculate_outlined,
                          widgetTarget: _calculator,
                          message: (state.inputState as KursFormBadInputState)
                              .message);
                      break;
                  }
                  context.read<KursPageBloc>().add(KursDismissFormState());
                }
                if (state.inputState is KursFormSuccess) {
                  await resultPopUp(context, true);
                  context.read<KursPageBloc>().add(KursDismissFormState());
                  Navigator.pop(context);
                } else if (state.inputState is KursFormFailed) {
                  await resultPopUp(context, false);
                  context.read<KursPageBloc>().add(KursDismissFormState());
                  Navigator.pop(context);
                }
              },
              child: SafeArea(
                  child: Scaffold(
                backgroundColor: mainColor,
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: mainColor)),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text('Pindah Kurs',
                      style: headerFontStyle.copyWith(color: mainColor)),
                ),
                body: ListView(children: [headerComp(), mainComp()]),
              )),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget headerComp() {
    return BlocBuilder<KursPageBloc, KursPageState>(
      builder: (context, state) {
        if (state is KursPageIdleState) {
          return Container(
            height: 80,
            width: DeviceScreen.devWidth,
            color: Colors.white,
            alignment: Alignment.center,
            child: Container(
              height: 40,
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ]),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  autofocus: true,
                  value: (state).selectedOutletSub,
                  dropdownMaxHeight: 200,
                  dropdownWidth: 150,
                  scrollbarAlwaysShow: true,
                  dropdownDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  items: state.availableOutletSub
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.outletName),
                          ))
                      .toList(),
                  onChanged: (val) {
                    context.read<KursPageBloc>().add(
                        KursSubOutletChangeEvent(newOutlet: val as OutletSub));
                  },
                  offset: const Offset(-10, -10),
                  style: blackFontStyle2.copyWith(
                      color: mainColor, fontWeight: FontWeight.w600),
                  isExpanded: true,
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              (state as KursPageErrorState).errorMessage,
              style: blackFontStyle.copyWith(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget mainComp() {
    return BlocBuilder<KursPageBloc, KursPageState>(
      builder: (context, state) {
        if (state is KursPageIdleState) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              color: Colors.transparent,
              height: DeviceScreen.devHeight - (80 + 56),
              width: DeviceScreen.devWidth,
              padding: const EdgeInsets.only(
                  bottom: 20, right: 10, left: 10, top: 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: 130,
                      key: _calculator,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          inputWidget(
                              context: context,
                              availablesCurrencies: (context
                                      .read<KursPageBloc>()
                                      .state as KursPageIdleState)
                                  .availableCurrencies,
                              hintText: 'Input Nominal',
                              key: _valueTextField,
                              onCurrencyChanged: (val) {
                                context.read<KursPageBloc>().add(
                                    KursCurrencyChangeEvent(newCurrency: val));
                              },
                              onValueChanged: (val) {
                                context.read<KursPageBloc>().add(
                                    KursInputValueChangeEvent(newValue: val));
                              },
                              selectedCurrencyValue: (context
                                      .read<KursPageBloc>()
                                      .state as KursPageIdleState)
                                  .selectedCurrency!,
                              textEditingController: valueController,
                              title: 'Dari'),
                          (state.inputState is KursFormSubmitting)
                              ? Container(
                                  margin: const EdgeInsets.only(top: 15),
                                  height: 40,
                                  width: DeviceScreen.devWidth,
                                  decoration: BoxDecoration(
                                      color: secondColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Menkonversi..',
                                        style: blackFontStyle2.copyWith(
                                            color: mainColor),
                                      ),
                                      const SizedBox(width: 15),
                                      loadingIndicator2
                                    ],
                                  ),
                                )
                              : inputWidget(
                                  keySymbol: _symbolCurrency,
                                  context: context,
                                  readOnly: false,
                                  availablesCurrencies: (context
                                          .read<KursPageBloc>()
                                          .state as KursPageIdleState)
                                      .availableToCurrencies
                                      .reversed
                                      .toList(),
                                  hintText: 'hasil konversi',
                                  key: _valueTextField2,
                                  onCurrencyChanged: (val) {
                                    context.read<KursPageBloc>().add(
                                        KursCurrencyToChangeEvent(
                                            newCurrency: val));
                                  },
                                  onValueChanged: (val) {
                                    context.read<KursPageBloc>().add(
                                        KursOutputValueChangeEvent(
                                            newValue: val));
                                  },
                                  selectedCurrencyValue: (context
                                          .read<KursPageBloc>()
                                          .state as KursPageIdleState)
                                      .selectedToCurrency!,
                                  textEditingController: valueController2,
                                  title: 'Ke'),
                        ],
                      ),
                    ),
                  ),
                  ((state).connectionStatus is InternetConnected)
                      ? SizedBox(
                          height: 50,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context
                                  .read<KursPageBloc>()
                                  .add(KursSubmitAttemptEvent());
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                backgroundColor:
                                    MaterialStateProperty.all(secondColor)),
                            child: Text(
                              'Submit',
                              style: blackFontStyle.copyWith(color: mainColor),
                            ),
                          ),
                        )
                      : Container(
                          height: 40,
                          width: DeviceScreen.devWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black87,
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.wifi_off_sharp,
                                    color: Colors.white),
                              ),
                              Text('No internet connection available',
                                  style: blackFontStyle2.copyWith(
                                      color: Colors.white))
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              (state as KursPageErrorState).errorMessage,
              style: blackFontStyle.copyWith(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget inputWidget({
    required BuildContext context,
    required GlobalKey key,
    GlobalKey? keySymbol,
    bool readOnly = true,
    required TextEditingController textEditingController,
    required Function(String) onValueChanged,
    required Function(Currency) onCurrencyChanged,
    required String title,
    required String hintText,
    required Currency selectedCurrencyValue,
    required List<Currency> availablesCurrencies,
  }) {
    return BlocBuilder<KursPageBloc, KursPageState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(title, style: blackFontStyle3.copyWith(color: Colors.white)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: DeviceScreen.devWidth - (100 + (10 * 2)),
                    height: 35,
                    key: key,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                    ),
                    child: TextField(
                      enabled: readOnly,
                      controller: textEditingController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => onValueChanged(val),
                      style: blackFontStyle2.copyWith(
                          color: mainColor, fontWeight: FontWeight.bold),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: greyFontStyle,
                          hintText: hintText),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            left: BorderSide(width: 1, color: Colors.black26))),
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.moneyBill,
                      color: mainColor,
                      size: 20,
                    ),
                  ),
                  Container(
                    width: 65,
                    height: 35,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        autofocus: true,
                        key: keySymbol,
                        value: selectedCurrencyValue,
                        dropdownMaxHeight: 200,
                        dropdownWidth: 150,
                        scrollbarAlwaysShow: true,
                        dropdownDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        items: availablesCurrencies
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.currencyName),
                                ))
                            .toList(),
                        onChanged: (val) => onCurrencyChanged(val as Currency),
                        offset: const Offset(-10, -10),
                        style: blackFontStyle2.copyWith(
                            color: mainColor, fontWeight: FontWeight.w600),
                        isExpanded: true,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
