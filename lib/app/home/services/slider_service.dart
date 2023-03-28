import 'package:flutter/material.dart';
import 'package:qixer/app/home/models/slider_model.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:http/http.dart' as http;

class SliderService {
  static Future<ApiReturnValue> fetchSlider(
    BuildContext context,
  ) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/slider';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['slider-details'].length, (index) {
            return SliderModel.formJson(
                responseRaw['slider-details'][index], responseRaw['image_url']);
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
