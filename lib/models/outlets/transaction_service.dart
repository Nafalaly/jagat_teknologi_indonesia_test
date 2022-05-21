part of '../models.dart';

class TransactionService {
  late String id;
  late String serviceName;
  late String serviceCodeName;
  late String outletId;

  TransactionService.fromJson({required Map apiData}) {
    id = apiData['id'];
    serviceName = apiData['nama'];
    serviceCodeName = apiData['trx'];
    outletId = apiData['outlet_id'];
  }
}
