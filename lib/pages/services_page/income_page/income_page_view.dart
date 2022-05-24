// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, use_build_context_synchronously

part of '../../screens.dart';

class IncomeServicePage extends StatelessWidget {
  IncomeServicePage({
    Key? key,
    required this.currentOutletSub,
    required this.currencies,
    required this.availableOutletSub,
  }) : super(key: key);
  final OutletSub currentOutletSub;
  final List<Currency> currencies;
  final List<OutletSub> availableOutletSub;
  Offset? fakeDropDownPosition;
  final GlobalKey _valueTextField = GlobalKey(debugLabel: 'value key');
  final GlobalKey _pictureKey = GlobalKey(debugLabel: 'picture key');

  double padding = 0;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    padding = MediaQuery.of(context).padding.top;
    return BlocProvider(
      create: (context) => IncomePageBloc(
          current:
              (context.read<UserAccountCubit>().state as UserAccountAttached)
                  .accountData,
          currentOutletSub: currentOutletSub,
          availableCurrencies: currencies,
          availableOutletSub: availableOutletSub,
          connection: context.read<ConnectivityCubit>()),
      child: BlocBuilder<IncomePageBloc, IncomePageState>(
        builder: (context, state) {
          if (state is IncomePageIdleState) {
            return BlocListener<IncomePageBloc, IncomePageState>(
              listener: (context, state) async {
                if ((state as IncomePageIdleState).inputState
                    is IncomeFormInteruptedByConnection) {
                  showWarning(
                      message: 'Tidak terhubung ke Internet',
                      color: Colors.black,
                      context: context,
                      onFinish: () {
                        context
                            .read<IncomePageBloc>()
                            .add(IncomeConnectionWarningDismiss());
                      });
                }
                if (state.inputState is IncomeFormBadInputState) {
                  switch ((state.inputState as IncomeFormBadInputState)
                      .badInputCode) {
                    case 501:
                      badInputFocus(
                          context: context,
                          icon: FontAwesomeIcons.moneyBill1,
                          widgetTarget: _valueTextField,
                          message: (state.inputState as IncomeFormBadInputState)
                              .message);
                      break;
                    case 502:
                      badInputFocus(
                          context: context,
                          icon: Icons.photo,
                          widgetTarget: _pictureKey,
                          message: (state.inputState as IncomeFormBadInputState)
                              .message);
                      break;
                  }
                  context.read<IncomePageBloc>().add(IncomeDismissFormState());
                }
                if (state.inputState is IncomeFormSuccess) {
                  await resultPopUp(context, true);
                  context.read<IncomePageBloc>().add(IncomeDismissFormState());
                  Navigator.pop(context);
                } else if (state.inputState is IncomeFormFailed) {
                  await resultPopUp(context, false);
                  context.read<IncomePageBloc>().add(IncomeDismissFormState());
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
                  title: Text('Masuk',
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
    return BlocBuilder<IncomePageBloc, IncomePageState>(
      builder: (context, state) {
        if (state is IncomePageIdleState) {
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
                    context.read<IncomePageBloc>().add(
                        IncomeSubOutletChangeEvent(
                            newOutlet: val as OutletSub));
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
              (state as IncomePageErrorState).errorMessage,
              style: blackFontStyle.copyWith(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget mainComp() {
    return BlocBuilder<IncomePageBloc, IncomePageState>(
      builder: (context, state) {
        if (state is IncomePageIdleState) {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      startDateWidget(context),
                      inputWidget(context),
                      uploadPicturesWidget(context),
                      descWidget(context)
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
                                  .read<IncomePageBloc>()
                                  .add(IncomeSubmitAttemptEvent());
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
              (state as IncomePageErrorState).errorMessage,
              style: blackFontStyle.copyWith(color: Colors.red),
            ),
          );
        }
      },
    );
  }

  Widget startDateWidget(BuildContext context) {
    return BlocBuilder<IncomePageBloc, IncomePageState>(
      builder: (context, state) {
        return Column(children: [
          Text('Start Date',
              style: blackFontStyle3.copyWith(color: Colors.white)),
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                onConfirm: (val) {
                  context
                      .read<IncomePageBloc>()
                      .add(IncomeStartDateChangeEvent(newDate: val));
                },
                maxTime: DateTime.now(),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              height: 35,
              width: DeviceScreen.devWidth,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(
                dateFormat((state as IncomePageIdleState).startDate),
                style: blackFontStyle3.copyWith(
                    color: mainColor, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]);
      },
    );
  }

  Widget descWidget(BuildContext context) {
    return BlocBuilder<IncomePageBloc, IncomePageState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('Keterangan',
                style: blackFontStyle3.copyWith(color: Colors.white)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: DeviceScreen.devWidth - (10 * 2),
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: TextField(
                      controller: descController,
                      onChanged: (val) => context
                          .read<IncomePageBloc>()
                          .add(IncomeDescriptionChangeEvent(newDesc: val)),
                      style: blackFontStyle2.copyWith(
                          color: mainColor, fontWeight: FontWeight.bold),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: greyFontStyle,
                          hintText: 'tambahkan keterangan disini'),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget inputWidget(BuildContext context) {
    return BlocBuilder<IncomePageBloc, IncomePageState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('Input', style: blackFontStyle3.copyWith(color: Colors.white)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    key: _valueTextField,
                    width: DeviceScreen.devWidth - (100 + (10 * 2)),
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                    ),
                    child: TextField(
                      controller: valueController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => context
                          .read<IncomePageBloc>()
                          .add(IncomeInputValueChangeEvent(newValue: val)),
                      style: blackFontStyle2.copyWith(
                          color: mainColor, fontWeight: FontWeight.bold),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: greyFontStyle,
                          hintText: "Nominal"),
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
                        value: (state as IncomePageIdleState).selectedCurrency,
                        dropdownMaxHeight: 200,
                        dropdownWidth: 150,
                        scrollbarAlwaysShow: true,
                        dropdownDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                        ),
                        items: state.availableCurrencies
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.currencyName),
                                ))
                            .toList(),
                        onChanged: (val) {
                          context.read<IncomePageBloc>().add(
                              IncomeCurrencyChangeEvent(
                                  newCurrency: val as Currency));
                        },
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

  Widget uploadPicturesWidget(BuildContext context) {
    double allocatedWidthSize = DeviceScreen.devWidth - (20);
    double allocatedHeightSize = 70;
    return BlocBuilder<IncomePageBloc, IncomePageState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('Photo', style: blackFontStyle3.copyWith(color: Colors.white)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              width: allocatedWidthSize,
              height: allocatedHeightSize,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Builder(builder: (_) {
                bool allowPicturesToAdd = true;
                try {
                  if ((state as IncomePageIdleState)
                          .getPicturesWidget()
                          .where((element) => !element.isDummy)
                          .length ==
                      4) {
                    allowPicturesToAdd = false;
                  }
                } on Exception {
                  allowPicturesToAdd = false;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      allowPicturesToAdd
                          ? 3
                          : (state as IncomePageIdleState)
                              .getPicturesWidget()
                              .length, (index) {
                    if ((state as IncomePageIdleState)
                        .getPicturesWidget()[index]
                        .isDummy) {
                      return Container(
                        height: allocatedHeightSize - 10,
                        width: allocatedWidthSize - 270,
                        decoration: BoxDecoration(
                            color: secondColor.withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ]),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => removePictureDialog(context, index),
                        child: Container(
                          height: allocatedHeightSize - 10,
                          width: allocatedWidthSize - 270,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ]),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Image.file(
                                (state).getPicturesWidget()[index].fileImg!,
                                fit: BoxFit.cover),
                          ),
                        ),
                      );
                    }
                  })
                    ..reversed
                    ..insert(
                        0,
                        allowPicturesToAdd
                            ? GestureDetector(
                                onTap: () => selectmethodtoupload(context),
                                child: Container(
                                  key: _pictureKey,
                                  height: allocatedHeightSize - 10,
                                  width: allocatedWidthSize - 270,
                                  decoration: BoxDecoration(
                                      color: secondColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Icon(Icons.camera_alt_outlined,
                                            color: mainColor, size: 30),
                                      ),
                                      Text('Tambahkan\nFoto',
                                          textAlign: TextAlign.center,
                                          style: greyFontStyle.copyWith(
                                              color: mainColor, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox()),
                );
              }),
            )
          ],
        );
      },
    );
  }

  void removePictureDialog(BuildContext context, int index) async {
    showDialog(
        context: context,
        builder: (BuildContext _) {
          return CupertinoAlertDialog(
            title: const Text('Hapus Foto ?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Batal'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  context
                      .read<IncomePageBloc>()
                      .add(IncomeRemovePictureEvent(indexPicture: index));
                },
                child: const Text('Hapus'),
              ),
            ],
          );
        });
  }

  void selectmethodtoupload(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext _) {
          return CupertinoAlertDialog(
            title: const Text('Tambahkan foto'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Upload Foto'),
                onPressed: () async {
                  Navigator.pop(context);
                  context
                      .read<IncomePageBloc>()
                      .add(IncomeAddPicture(source: ImageSource.gallery));
                },
              ),
              CupertinoDialogAction(
                child: const Text('Camera'),
                onPressed: () async {
                  Navigator.pop(context);
                  context
                      .read<IncomePageBloc>()
                      .add(IncomeAddPicture(source: ImageSource.camera));
                },
              ),
            ],
          );
        });
  }
}

Future<void> resultPopUp(BuildContext context, bool isSuccess) async {
  await showDialog(
      context: context,
      builder: (BuildContext _) {
        return CupertinoAlertDialog(
          title: Text('Info',
              style: blackFontStyle2.copyWith(
                  color: isSuccess ? Colors.green : Colors.red)),
          content: Text(isSuccess ? 'Transaksi berhasil' : 'Transaksi Gagal',
              style: blackFontStyle3),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
  return;
}

void badInputFocus(
    {required BuildContext context,
    required GlobalKey widgetTarget,
    required String message,
    required IconData icon}) {
  List<TargetFocus> targets = [
    TargetFocus(
        identify: "Target 1",
        keyTarget: widgetTarget,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(icon, color: Colors.white, size: 40),
                      const SizedBox(width: defaultMargin),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Oops",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ))
        ])
  ];
  TutorialCoachMark tutorial = TutorialCoachMark(context,
      targets: targets, // List<TargetFocus>
      hideSkip: true,
      onFinish: () {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickTarget: (target) {},
      onSkip: () {});
  tutorial.show();
}
