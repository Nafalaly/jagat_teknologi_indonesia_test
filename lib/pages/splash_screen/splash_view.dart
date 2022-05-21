// ignore_for_file: file_names
part of '../screens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
    ));
    return BlocProvider(
        create: (context) =>
            SplashScreenBloc(accountCubit: context.read<UserAccountCubit>())
              ..add(SplashScreenLoadData()),
        child: BlocListener<SplashScreenBloc, SplashScreenState>(
          listener: (context, state) {
            if (state is SplashScreenLoadProcessComplete) {
              if (state.hasAccount) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const Dashboard();
                }), (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return LoginScreen();
                }), (route) => false);
              }
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              height: DeviceScreen.devHeight,
              width: DeviceScreen.devWidth,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 400,
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(logoOnly))),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      loadingIndicator
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
