import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkState {
  Future<bool> get isConnected;
}

class NetworkStateImpl implements NetworkState {
  final InternetConnectionChecker connectionChecker;

  NetworkStateImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
