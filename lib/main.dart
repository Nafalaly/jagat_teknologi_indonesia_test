import 'dart:io';
import 'package:jagat_teknologi_indonesia_test/independent_controller/user_account/user_account_cubit.dart';
import 'package:jagat_teknologi_indonesia_test/pages/screens.dart';
import 'package:jagat_teknologi_indonesia_test/services/services.dart';

import 'independent_controller/connectivity_controller/connectivity_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(
      connection: Connectivity(),
    ));
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.connection}) : super(key: key);
  final Connectivity connection;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                ConnectivityCubit(internetAdaptor: connection)),
        BlocProvider(create: (context) => UserAccountCubit()),
      ],
      child: MaterialApp(
        initialRoute: '/SplashScreen',
        routes: {
          '/Dashboard': (context) => const Dashboard(),
          '/SplashScreen': (context) => const SplashScreen(),
          '/LoginScreen': (context) => LoginScreen(),
        },
        theme: ThemeData(primarySwatch: Colors.blue),
        builder: (context, child) {
          DeviceScreen.setup(context: context);
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(0.8, 0.8);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!,
          );
        },
        title: 'App Keuangan',
      ),
    );
  }
}
