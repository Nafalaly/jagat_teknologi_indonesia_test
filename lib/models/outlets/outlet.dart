part of '../models.dart';

class Outlet {
  Outlet();
  late final String id;
  late String outletName;
  late String outletCode;
  late String outletAddress;
  late String outletPhone;
  late String outletCurrency;
  late String outletUserId;
  late String outletParentId;
  late String outletOrderId;
  List<OutletSub> outletSubs = [];
  List<TransactionService> services = [];
  List<PaymentMethod> paymentMethods = [];
  List<Currency> currencies = [];
  Outlet.fromJson({required Map apiData}) {
    id = apiData['outlet']['id'];
    outletName = apiData['outlet']['outlet_name'];
    outletCode = apiData['outlet']['outlet_code'];
    outletAddress = apiData['outlet']['outlet_address'];
    outletPhone = apiData['outlet']['outlet_phone'];
    outletCurrency = apiData['outlet']['currency'];
    outletUserId = apiData['outlet']['user_id'];
    outletParentId = apiData['outlet']['parent_id'];
    outletOrderId = apiData['outlet']['order_id'];
    _addOutletSubs(apiData: apiData);
    _addServices(apiData: apiData);
    _addPaymentMethods(apiData: apiData);
    _addCurrencies(apiData: apiData);
  }

  _addServices({required Map apiData}) {
    int length = apiData['trx_tipe'].length;
    for (int i = 0; i < length; i++) {
      services
          .add(TransactionService.fromJson(apiData: apiData['trx_tipe'][i]));
    }
  }

  _addCurrencies({required Map apiData}) {
    int length = apiData['cur_tipe'].length;
    for (int i = 0; i < length; i++) {
      currencies.add(Currency.fromJson(apiData: apiData['cur_tipe'][i]));
    }
  }

  _addPaymentMethods({required Map apiData}) {
    int length = apiData['pay_tipe'].length;
    for (int i = 0; i < length; i++) {
      paymentMethods
          .add(PaymentMethod.fromJson(apiData: apiData['pay_tipe'][i]));
    }
  }

  _addOutletSubs({required Map apiData}) {
    int length = apiData['outlet_subs'].length;
    for (int i = 0; i < length; i++) {
      outletSubs.add(OutletSub.fromJson(apiData: apiData['outlet_subs'][i]));
    }
  }
}

class OutletSub {
  late String id;
  late String outletName;
  late String parentId;
  late String orderId;

  OutletSub.fromJson({required Map apiData}) {
    id = apiData['id'];
    outletName = apiData['outlet_name'];
    parentId = apiData['parent_id'];
    orderId = apiData['order_id'];
  }
}
