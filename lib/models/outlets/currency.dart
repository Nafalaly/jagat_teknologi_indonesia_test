part of '../models.dart';

class Currency {
  Currency() {
    id = currencyLogo = currencyDesc = currencyName = 'No Data';
  }
  late String id;
  late String currencyName;
  late String currencyLogo;
  late String currencyDesc;

  Currency.fromJson({required Map apiData}) {
    id = apiData['ct_id'];
    currencyName = apiData['ct_nama'];
    currencyLogo = apiData['ct_logo'];
    currencyDesc = apiData['ct_ket'];
  }
}
