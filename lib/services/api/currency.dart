part of '../services.dart';

class APICurrency {
  APICurrency();
  Dio dio = Dio();

  Future<String> convert({
    required String from,
    required String to,
    required String ammount,
  }) async {
    ResponseParser parser = ResponseParser();
    try {
      Map<String, dynamic>? header = {
        "Content-Type": "text/plain",
        "apikey": "xKaB7MbHWW8JpxNtNcXJRkBtzUT1ivCz"
      };
      Map<String, dynamic>? data = {"from": from, "to": to, "amount": ammount};
      final Response responseku = await dio.get(BaseUrl.currencyConverter,
          queryParameters: data, options: Options(headers: header));
      return responseku.data['result'].toString();
    } on DioError catch (e) {
      return '0';
    }
  }
}
