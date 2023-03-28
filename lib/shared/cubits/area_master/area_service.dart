import 'package:flutter/material.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/cubits/area_master/area_model.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:http/http.dart' as http;

class AreaService {
  static Future<ApiReturnValue> fetchArea(BuildContext context,
      {required String idCity}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/country/service-city/service-area/1/$idCity';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: false);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['service_areas'].length, (index) {
            return Area.fromJson(responseRaw['service_areas'][index]);
          }),
          status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['message'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }
}
