part of '../services.dart';

class ResponseParser {
  late _Meta _meta;
  dynamic _data;
  ResponseParser() {
    _meta = _Meta.init();
    _data = null;
  }
  ResponseParser.parse({required dynamic mapData}) {
    _meta = _Meta.createMeta(mapData: mapData['status']);
    // ignore: unnecessary_null_in_if_null_operators
    _data = mapData['data'] ?? null;
  }

  ResponseParser.error({dynamic mapData}) {
    if (mapData != null) {
      _data = mapData;
    } else {
      _data = null;
    }
    _meta = _Meta.createMeta(mapData: mapData);
  }

  Map? get getData => _data;
  int? get getStatusCode => _meta.responseCode;
  String? get getMessage => _meta.message;
  ResponseStatus? get getStatus => _meta.status;
}

class _Meta {
  late int responseCode;
  late ResponseStatus status;
  late String? message;
  _Meta.init() {
    message = 'Unimplemented';
    status = ResponseStatus.initialized;
    responseCode = 501;
  }
  _Meta.createMeta({required dynamic mapData}) {
    responseCode = mapData['error'];
    message = mapData['message'] ?? 'No Message from server';
    if (mapData['error'] == 0) {
      status = ResponseStatus.success;
    } else {
      status = ResponseStatus.error;
    }
  }
}

enum ResponseStatus { error, success, initialized, internalError }
