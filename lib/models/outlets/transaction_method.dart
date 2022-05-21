part of '../models.dart';

class PaymentMethod {
  late String id;
  late String transactionName;
  late String transactionDesc;
  late String transactionQrisData;
  late String transactionQrisImage;
  late String outletId;

  PaymentMethod.fromJson({required Map apiData}) {
    id = apiData['byr_id'];
    transactionName = apiData['byr_nama'];
    transactionQrisData = apiData['byr_qris_data'];
    transactionQrisImage = apiData['byr_qris_image'];
    transactionDesc = apiData['byr_desc'];
    outletId = apiData['outlet_id'];
  }
}
