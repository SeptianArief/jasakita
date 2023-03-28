import 'package:flutter/material.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:http/http.dart' as http;

class CityService {
  static Future<ApiReturnValue> fetchCity(
    BuildContext context,
  ) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/country/service-city/1';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: false);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['service_cities'].length, (index) {
            return City.formJson(responseRaw['service_cities'][index]);
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

  static Future<ApiReturnValue> availableCity(
    BuildContext context,
  ) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/available-city';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: false);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['list_service_city'].length, (index) {
            return City.formJson(responseRaw['list_service_city'][index]);
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
