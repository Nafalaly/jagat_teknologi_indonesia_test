part of '../services.dart';

class APIUserService {
  APIUserService();
  UserData userData = UserData();
  Dio dio = Dio();

  Future<ResponseParser> loginUser({
    required String user,
    required String pass,
  }) async {
    ResponseParser parser = ResponseParser();
    try {
      Map data = {"act": "LOGIN", "un": user, "up": pass};
      final Response responseku =
          await dio.post(BaseUrl.loginToAccount, data: json.encode(data));
      parser = ResponseParser.parse(mapData: responseku.data);
      return parser;
    } on DioError catch (e) {
      Map response = {
        'code': e.response!.statusCode,
        'message': e.response!.data['meta']['message'],
      };
      parser = ResponseParser.error(mapData: response);
      return parser;
    }
  }
}
