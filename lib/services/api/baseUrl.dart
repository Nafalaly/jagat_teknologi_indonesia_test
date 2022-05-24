// ignore_for_file: file_names, prefer_final_fields

part of '../services.dart';

class BaseUrl {
  //Home
  static const String _baseURL =
      'http://test-tech.api.jtisrv.com/md/public/API/';

  static String loginToAccount = '${_baseURL}Auth';

  static String initialData = '${_baseURL}Auth/initData';
  static String incomeService = '${_baseURL}Trx/Add';

  static const String backroundHit =
      'http://test-tech.api.jtisrv.com/md/public/API/BgService/Hit';
}
