part of '../services.dart';

class APITransaction {
  APITransaction();
  Dio dio = Dio();

  Future<ResponseParser> uploadIncomeOutCome({required dynamic state}) async {
    ResponseParser parser = ResponseParser();
    try {
      Map data = {
        "act": "trxAdd",
        "outlet_id": 1,
        "user_id": int.parse(state.currentUser.userId),
        "data": _getIncomeData(state),
      };

      final Response responseku =
          await dio.post(BaseUrl.incomeService, data: json.encode(data));

      parser = ResponseParser.parse(mapData: responseku.data);

      return parser;
    } on DioError catch (e) {
      Map response = {
        'code': e.response!.statusCode,
        'message': e.response!.data['meta']['message'],
      };
      parser = ResponseParser.error(mapData: response);
      return parser;
    } on Exception {
      return parser;
    }
  }

  Map _getIncomeData(dynamic state) {
    Map data = {
      'ptipe': (state is IncomePageIdleState) ? 1 : 2,
      'curr_id': int.parse(state.selectedCurrency!.id),
      'nominal': state.inputValue.toString(),
      'outlet_id1': int.parse(state.selectedOutletSub!.id),
      'ket': state.desc,
    };

    for (int i = 0; i < state.pictures.length; i++) {
      var key = 'photo';
      if (i != 0) {
        key = 'key${i + 1}';
      }
      List<int> imageBytes = state.pictures[i].readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      data[key] = base64Image;
    }
    return data;
  }
}
