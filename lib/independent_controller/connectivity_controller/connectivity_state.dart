import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState {
  const ConnectivityState();
}

class InternetInitial extends ConnectivityState {
  const InternetInitial();
}

class InternetConnected extends ConnectivityState {
  const InternetConnected();
}

class NoInternetConnections extends ConnectivityState {
  const NoInternetConnections();
}
