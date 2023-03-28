import 'package:flutter/material.dart';
import 'package:qixer/app/home/models/service_model.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:http/http.dart' as http;

class ServiceService {
  static Future<ApiReturnValue> fetchByCity(BuildContext context,
      {required String city}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/service_per_categories/${city.toLowerCase()}';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['service_per_categories'].length,
              (index) {
            return ServiceGrouping.fromJson(
              responseRaw['service_per_categories'][index],
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

  static Future<ApiReturnValue> fetchSearch(BuildContext context,
      {required String city, String search = ''}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/home/home-search';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['service_city_id'] = city;
    requestVar.fields['search_text'] = search;
    requestVar.fields['is_service_online'] = '1';

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [
        201,
      ],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['services'].length, (index) {
            return ServiceModel.fromJsonToSearch(
                responseRaw['services'][index], responseRaw['service_image']);
          }),
          status: RequestStatus.successRequest);
    } else {
      List<ServiceModel> data = [];
      returnValue =
          ApiReturnValue(data: data, status: RequestStatus.successRequest);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> finishOrder(
    BuildContext context, {
    required String orderId,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/order/request/status/complete/approve';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['order_id'] = orderId;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [
        201,
      ],
    );

    if (response!.status == RequestStatus.successRequest) {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.successRequest);
    } else {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.failedRequest);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> declineOrder(BuildContext context,
      {required String orderId,
      required String sellerId,
      required String reason}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/order/request/status/complete/decline';

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpPostRequest(
      context,
      dataBody: {
        'order_id': orderId,
        'seller_id': sellerId,
        'decline_reason': reason
      },
      url: url,
      exceptionStatusCode: [201, 404],
    );

    if (response!.status == RequestStatus.successRequest) {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.successRequest);
    } else {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.failedRequest);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> fetchByCategory(BuildContext context,
      {required String idCategory, String? stateId, String page = '1'}) async {
    ApiReturnValue returnValue;

    String url = '';

    if (stateId == null) {
      url = '$baseApi/service-list/search-by-category/$idCategory?page=$page';
    } else {
      url =
          '$baseApi/service-list/search-by-category/$idCategory?page=$page&state_id=$stateId';
    }

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201, 404],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      if (responseRaw.toString().contains('Service Not Found')) {
        List<ServiceModel> data = [];
        returnValue =
            ApiReturnValue(data: data, status: RequestStatus.successRequest);
      } else {
        returnValue = ApiReturnValue(
            data: List.generate(responseRaw['all_services']['data'].length,
                (index) {
              return ServiceModel.fromJsonToCategories(
                  responseRaw['all_services']['data'][index],
                  responseRaw['service_image']);
            }),
            status: RequestStatus.successRequest);
      }
    } else {
      String? messages;
      try {
        messages = response.data['message'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> fetchNew(
    BuildContext context,
  ) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/latest-services';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['latest_services'].length, (index) {
            return ServiceModel.fromJsonNew(
                responseRaw['latest_services'][index],
                responseRaw['service_image'],
                responseRaw['reviewer_image']);
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

  static Future<ApiReturnValue> fetchDetailService(BuildContext context,
      {required String id}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/service-details/$id';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: ServiceDetail.fromJson(responseRaw),
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

  static Future<ApiReturnValue> fetchDetailServiceBooking(BuildContext context,
      {required String id}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/service-list/service-book/$id';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
      context,
      request: requestVar,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: ServiceBookingModel.fromJson(responseRaw),
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
