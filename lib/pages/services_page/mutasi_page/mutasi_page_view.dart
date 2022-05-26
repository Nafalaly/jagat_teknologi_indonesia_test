// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously

part of '../../screens.dart';

class MutasiServicePage extends StatelessWidget {
  MutasiServicePage({
    Key? key,
    required this.currencies,
    required this.availableOutletSub,
    required this.curentOutlet,
  }) : super(key: key);
  final List<Currency> currencies;
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
      create: (context) => MutasiPageBloc(
          current:
              (context.read<UserAccountCubit>().state as UserAccountAttached)
                  .accountData,
          availableCurrencies: currencies,
          connection: context.read<ConnectivityCubit>(),
          availableOutletSub: availableOutletSub,
          currentOutletSub: curentOutlet),
      child: BlocBuilder<MutasiPageBloc, MutasiPageState>(
        builder: (context, state) {
          if (state is MutasiPageIdleState) {
            return BlocListener<MutasiPageBloc, MutasiPageState>(
              listener: (context, state) async {
                if (state is MutasiPageIdleState) {
                  valueController2.text = state.outputValue.toString();
                }
                if ((state as MutasiPageIdleState).inputState
                    is MutasiFormInteruptedByConnection) {
                  showWarning(
                      message: 'Tidak terhubung ke Internet',
                      color: Colors.black,
                      context: context,
                      onFinish: () {
                        context
                            .read<MutasiPageBloc>()
                            .add(MutasiConnectionWarningDismiss());
                      });
                }
                if (state.inputState is MutasiFormSuccess) {
                  await resultPopUp(context, true);
                  context.read<MutasiPageBloc>().add(MutasiDismissFormState());
                } else if (state.inputState is MutasiFormFailed) {
                  await resultPopUp(context, false);
                  context.read<MutasiPageBloc>().add(MutasiDismissFormState());
                }
              },
              child: SafeArea(
                  child: Stack(
                children: [
                  Scaffold(
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
                      title: Text('Mutasi',
                          style: headerFontStyle.copyWith(color: mainColor)),
                    ),
                    body: ListView(children: [headerComp(context), mainComp()]),
                  ),
                  (state.filterPanelState is PanelOpened)
                      ? filterPanel(context)
                      : const SizedBox(),
                ],
              )),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget filterPanel(BuildContext context) {
    return Container(
      height: DeviceScreen.devHeight,
      width: DeviceScreen.devWidth,
      color: Colors.black87,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          context.read<MutasiPageBloc>().add(MutasiCloseFilterPanelEvent());
        },
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context
                      .read<MutasiPageBloc>()
                      .add(MutasiCloseFilterPanelEvent()),
                  child: Container(
                    height: 40,
                    width: 260,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 15, top: 120),
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Jenis Laporan',
                            style: blackFontStyle2.copyWith(
                                color: mainColor, fontWeight: FontWeight.bold)),
                        BlocBuilder<MutasiPageBloc, MutasiPageState>(
                          builder: (context, state) {
                            return Text(
                                (context.read<MutasiPageBloc>().state.useFilter)
                                    ? '${dateFormat(context.read<MutasiPageBloc>().state.startDate)}-${dateFormat(context.read<MutasiPageBloc>().state.toDate)}'
                                    : 'Pilih Semua',
                                style:
                                    blackFontStyle3.copyWith(color: mainColor));
                          },
                        ),
                        const Icon(
                          Icons.arrow_drop_up,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: DeviceScreen.devWidth - defaultMargin,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Filter',
                          style: blackFontStyle.copyWith(
                              color: mainColor, fontWeight: FontWeight.bold)),
                      Container(
                        height: 35,
                        width: 180,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Jenis Laporan',
                                style: blackFontStyle2.copyWith(
                                    color: mainColor,
                                    fontWeight: FontWeight.bold)),
                            const Icon(
                              Icons.arrow_drop_down_outlined,
                            )
                          ],
                        ),
                      ),
                      BlocBuilder<MutasiPageBloc, MutasiPageState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: state.useFilter,
                                onChanged: (value) {
                                  context.read<MutasiPageBloc>().add(
                                      MutasiUseFilterSwitch(
                                          switchState: value!));
                                },
                              ),
                              Text('Filter berdasarkan waktu',
                                  style: blackFontStyle3.copyWith(
                                      color: mainColor))
                            ],
                          );
                        },
                      ),
                      (context.read<MutasiPageBloc>().state.useFilter)
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  BlocBuilder<MutasiPageBloc, MutasiPageState>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          Text('Start Date',
                                              style: blackFontStyle3.copyWith(
                                                  color: mainColor)),
                                          GestureDetector(
                                            onTap: () {
                                              DatePicker.showDatePicker(
                                                context,
                                                onConfirm: (val) {
                                                  context
                                                      .read<MutasiPageBloc>()
                                                      .add(
                                                          MutasiStartDateChangeEvent(
                                                              newDate: val));
                                                },
                                                maxTime: DateTime.now()
                                                    .subtract(const Duration(
                                                        days: 1)),
                                              );
                                            },
                                            child: Container(
                                              width: 125,
                                              height: 35,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: secondColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ]),
                                              child: Text(
                                                  dateFormat(context
                                                      .read<MutasiPageBloc>()
                                                      .state
                                                      .startDate),
                                                  style:
                                                      blackFontStyle2.copyWith(
                                                          color: mainColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  BlocBuilder<MutasiPageBloc, MutasiPageState>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          Text('End Date',
                                              style: blackFontStyle3.copyWith(
                                                  color: mainColor)),
                                          GestureDetector(
                                            onTap: () {
                                              DatePicker.showDatePicker(context,
                                                  onConfirm: (val) {
                                                context
                                                    .read<MutasiPageBloc>()
                                                    .add(
                                                        MutasiToDateChangeEvent(
                                                            newDate: val));
                                              },
                                                  maxTime: DateTime.now(),
                                                  minTime: context
                                                      .read<MutasiPageBloc>()
                                                      .state
                                                      .startDate);
                                            },
                                            child: Container(
                                              width: 125,
                                              height: 35,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: secondColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ]),
                                              child: Text(
                                                  dateFormat(context
                                                      .read<MutasiPageBloc>()
                                                      .state
                                                      .toDate),
                                                  style:
                                                      blackFontStyle2.copyWith(
                                                          color: mainColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<MutasiPageBloc>()
                                .add(MutasiCloseFilterPanelEvent());
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(5),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              backgroundColor:
                                  MaterialStateProperty.all(mainColor)),
                          child: Text(
                            'Submit',
                            style: blackFontStyle.copyWith(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headerComp(BuildContext context) {
    return BlocBuilder<MutasiPageBloc, MutasiPageState>(
      builder: (context, state) {
        if (state is MutasiPageIdleState) {
          return Container(
            height: 120,
            width: DeviceScreen.devWidth,
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 150,
                  margin: const EdgeInsets.only(bottom: 15),
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
                        context.read<MutasiPageBloc>().add(
                            MutasiSubOutletChangeEvent(
                                newOutlet: val as OutletSub));
                      },
                      offset: const Offset(-10, -10),
                      style: blackFontStyle2.copyWith(
                          color: mainColor, fontWeight: FontWeight.w600),
                      isExpanded: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context
                      .read<MutasiPageBloc>()
                      .add(MutasiOpenFilterPanelEvent()),
                  child: (state.filterPanelState is PanelClosed)
                      ? Container(
                          height: 40,
                          width: 260,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: secondColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Jenis Laporan',
                                  style: blackFontStyle2.copyWith(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  (context
                                          .read<MutasiPageBloc>()
                                          .state
                                          .useFilter)
                                      ? '${dateFormat(context.read<MutasiPageBloc>().state.startDate)}-${dateFormat(context.read<MutasiPageBloc>().state.toDate)}'
                                      : 'Pilih semua',
                                  style: blackFontStyle3.copyWith(
                                      color: mainColor)),
                              const Icon(
                                Icons.arrow_drop_down_outlined,
                              )
                            ],
                          ),
                        )
                      : const SizedBox(height: 40),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              (state as MutasiPageErrorState).errorMessage,
              style: blackFontStyle.copyWith(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget mainComp() {
    return BlocBuilder<MutasiPageBloc, MutasiPageState>(
      builder: (context, state) {
        if (state is MutasiPageIdleState) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              color: Colors.transparent,
              height: DeviceScreen.devHeight - (120 + 56),
              width: DeviceScreen.devWidth,
              padding: const EdgeInsets.only(
                  bottom: 20, right: 10, left: 10, top: 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      inputWidget(
                          context: context,
                          availablesCurrencies: (context
                                  .read<MutasiPageBloc>()
                                  .state as MutasiPageIdleState)
                              .availableCurrencies,
                          hintText: 'Input Nominal',
                          key: _valueTextField,
                          onCurrencyChanged: (val) {
                            context.read<MutasiPageBloc>().add(
                                MutasiCurrencyChangeEvent(newCurrency: val));
                          },
                          onValueChanged: (val) {
                            context.read<MutasiPageBloc>().add(
                                MutasiInputValueChangeEvent(newValue: val));
                          },
                          selectedCurrencyValue: (context
                                  .read<MutasiPageBloc>()
                                  .state as MutasiPageIdleState)
                              .selectedCurrency!,
                          textEditingController: valueController,
                          title: 'Dari'),
                      inputWidget(
                          keySymbol: _symbolCurrency,
                          context: context,
                          readOnly: false,
                          availablesCurrencies: (context
                                  .read<MutasiPageBloc>()
                                  .state as MutasiPageIdleState)
                              .availableToCurrencies
                              .reversed
                              .toList(),
                          hintText: 'hasil konversi',
                          key: _valueTextField2,
                          onCurrencyChanged: (val) {
                            context.read<MutasiPageBloc>().add(
                                MutasiCurrencyToChangeEvent(newCurrency: val));
                          },
                          onValueChanged: (val) {
                            context.read<MutasiPageBloc>().add(
                                MutasiOutputValueChangeEvent(newValue: val));
                          },
                          selectedCurrencyValue: (context
                                  .read<MutasiPageBloc>()
                                  .state as MutasiPageIdleState)
                              .selectedToCurrency!,
                          textEditingController: valueController2,
                          title: 'Ke'),
                    ],
                  ),
                  ((state).connectionStatus is InternetConnected)
                      ? SizedBox(
                          height: 50,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context
                                  .read<MutasiPageBloc>()
                                  .add(MutasiSubmitAttemptEvent());
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
              (state as MutasiPageErrorState).errorMessage,
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
    return BlocBuilder<MutasiPageBloc, MutasiPageState>(
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
