import 'package:flutter/material.dart';
import 'package:qixer/app/home/models/categories_model.dart';
import 'package:qixer/app/home/models/slider_model.dart';
import 'package:qixer/app/home/models/vendor_model.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:http/http.dart' as http;

class VendorService {
  static Future<ApiReturnValue> fetchVendorHome(
    BuildContext context,
  ) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/seller/seller-list';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['seller_list'].length, (index) {
            return VendorModelPreview.fromJson(
              responseRaw['seller_list'][index],
            );
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

  static Future<ApiReturnValue> fetchVendorDetail(BuildContext context,
      {required String id}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/seller/seller-detail/$id';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: VendorDetail.fromJson(
            responseRaw['seller_detail'],
          ),
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
