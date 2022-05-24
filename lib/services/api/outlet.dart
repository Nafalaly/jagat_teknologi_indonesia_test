part of '../services.dart';

class APIOutlet {
  APIOutlet();
  Dio dio = Dio();

  Future<ResponseParser> fetchInitialData(
      // required String outletId,
      ) async {
    ResponseParser parser = ResponseParser();
    try {
      Map<String, dynamic> data = {"act": "initData", "outlet_id": 1};
      final Response responseku =
          await dio.get(BaseUrl.initialData, queryParameters: data);
      parser = ResponseParser.parse(mapData: responseku.data);
      return parser;
    } on DioError catch (e) {
      Map response;
      if (e.error.osError.errorCode == 7) {
        response = {
          'code': 501,
          'message': 'No Internet Connection',
        };
      } else {
        response = {
          'code': e.response!.statusCode,
          'message': e.response!.data['meta']['message'],
        };
      }
      parser = ResponseParser.error(mapData: response);
      return parser;
    }
  }
}
