import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qixer/app/home/models/slider_model.dart';
import 'package:qixer/app/order/model/order_model.dart';
import 'package:qixer/app/order/model/report_list_model.dart';
import 'package:qixer/app/order/model/ticket_list_model.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/cubits/city_master/city_model.dart';
import 'package:qixer/shared/models/api_return_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static Future<ApiReturnValue> bookingService(BuildContext context,
      {required String sellerId,
      required String buyerId,
      required List<dynamic> included,
      required List<dynamic> extras,
      required List<int> selectedExtra,
      required String serviceId,
      required String name,
      required String phone,
      required String email,
      required String postCode,
      required String address,
      required String selectedDate,
      required String selectedSchedule,
      required String coupon,
      required String notes,
      String? selectedBrand}) async {
    ApiReturnValue returnValue;

    List includesList = [];
    List extrasList = [];

    //includes list
    for (int i = 0; i < included.length; i++) {
      includesList.add({
        'order_id': "1",
        "title": included[i]['include_service_title'],
        "price": included[i]['include_service_price'],
        "quantity": included[i]['include_service_quantity']
      });
    }

    //extras list
    for (int i = 0; i < extras.length; i++) {
      if (selectedExtra.contains(extras[i]['id'])) {
        extrasList.add({
          'order_id': "1",
          "additional_service_title": extras[i]['additional_service_title'],
          "additional_service_price": extras[i]['additional_service_price'],
          "quantity": extras[i]['additional_service_quantity']
        });
      }
    }

    var requestSend = http.MultipartRequest(
      'POST',
      Uri.parse('$baseApi/service/order'),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    requestSend.fields['seller_id'] = sellerId.toString();
    requestSend.fields['buyer_id'] = prefs.getInt('userId').toString();
    requestSend.fields['service_id'] = serviceId.toString();
    requestSend.fields['name'] = name;
    requestSend.fields['phone'] = phone;
    requestSend.fields['email'] = email;
    requestSend.fields['post_code'] = postCode;
    requestSend.fields['address'] = address;
    requestSend.fields['date'] = selectedDate;
    requestSend.fields['schedule'] = selectedSchedule;
    requestSend.fields['coupon_code'] = coupon.toString();
    requestSend.fields['payment_method'] = 'xendit';
    requestSend.fields['is_service_online'] = '0';
    requestSend.fields['brands'] = selectedBrand ?? '';
    requestSend.fields['order_note'] = notes;
    requestSend.fields['include_services'] =
        json.encode({'include_services': includesList});
    requestSend.fields['additional_services'] =
        json.encode({'additional_services': extrasList});

    requestSend.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    // ignore: use_build_context_synchronously
    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestSend,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: responseRaw['payment_redirect_url'].toString(),
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

  static Future<ApiReturnValue> applyCoupon(
    BuildContext context, {
    required String coupon,
    required String totalAmount,
    required String sellerId,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/service-list/coupon-apply';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['coupon_code'] = coupon;
    requestVar.fields['total_amount'] = totalAmount;
    requestVar.fields['seller_id'] = sellerId;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: responseRaw['coupon_amount'].toString(),
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

  static Future<ApiReturnValue> writeReview(
    BuildContext context, {
    required String rating,
    required String name,
    required String email,
    required String message,
    required String orderId,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/add-service-rating/$orderId';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['rating'] = rating;
    requestVar.fields['name'] = name;
    requestVar.fields['email'] = email;
    requestVar.fields['message'] = message;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['message'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> cancelOrder(
    BuildContext context, {
    required String orderId,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/seller/my-orders/order/change-status';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['id'] = orderId;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201, 500],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['message'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> reportToAdmin(BuildContext context,
      {required String message,
      required String orderId,
      required String serviceId}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/report/create';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['order_id'] = orderId;
    requestVar.fields['service_id'] = serviceId;
    requestVar.fields['report'] = message;

    ApiReturnValue<dynamic>? response =
        await ApiReturnValue.httpRequest(context,
            request: requestVar,
            exceptionStatusCode: [
              201,
            ],
            auth: true);

    if (response!.status == RequestStatus.successRequest) {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['msg'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> createTicket(BuildContext context,
      {required String subject,
      required String priority,
      required String orderId,
      required String desc}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/ticket/create';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['order_id'] = orderId;
    requestVar.fields['subject'] = subject;
    requestVar.fields['priority'] = priority;
    requestVar.fields['description'] = desc;

    ApiReturnValue<dynamic>? response =
        await ApiReturnValue.httpRequest(context,
            request: requestVar,
            exceptionStatusCode: [
              201,
            ],
            auth: true);

    if (response!.status == RequestStatus.successRequest) {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['msg'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> reportList(
    BuildContext context, {
    String page = '0',
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/report/list?page=$page';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    ApiReturnValue<dynamic>? response =
        await ApiReturnValue.httpRequest(context,
            request: requestVar,
            exceptionStatusCode: [
              201,
            ],
            auth: true);

    if (response!.status == RequestStatus.successRequest) {
      returnValue = ApiReturnValue(
          data: ReportListModelMaster.fromJson(response.data),
          status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['msg'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> ticketList(
    BuildContext context, {
    String page = '0',
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/support-tickets?page=$page';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    ApiReturnValue<dynamic>? response =
        await ApiReturnValue.httpRequest(context,
            request: requestVar,
            exceptionStatusCode: [
              201,
            ],
            auth: true);

    if (response!.status == RequestStatus.successRequest) {
      returnValue = ApiReturnValue(
          data: TicketMasterModel.fromJson(response.data['tickets']),
          status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['msg'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> fetchOrderList(
    BuildContext context,
  ) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/my-orders';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: List.generate(responseRaw['my_orders'].length, (index) {
            return OrderPreview.fromJson(
              responseRaw['my_orders'][index],
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

  static Future<ApiReturnValue> fetchSchedule(BuildContext context,
      {required String selectedWeek, required String sellerId}) async {
    ApiReturnValue returnValue;

    String url =
        '$baseApi/service-list/service-schedule/$selectedWeek/$sellerId';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      if (response.data.toString().contains('day')) {
        returnValue = ApiReturnValue(
            data: List.generate(responseRaw['schedules'].length, (index) {
              return responseRaw['schedules'][index]['schedule'];
            }),
            status: RequestStatus.successRequest);
      } else {
        returnValue =
            ApiReturnValue(data: [], status: RequestStatus.successRequest);
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

  static Future<ApiReturnValue> fetchDeclineHistory(
    BuildContext context, {
    required String orderId,
  }) async {
    ApiReturnValue returnValue;

    String url =
        '$baseApi/user/order/request/complete/decline/history?order_id=$orderId';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: responseRaw, status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['message'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> fetchDetailOrder(BuildContext context,
      {required String orderId}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/my-orders/$orderId';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: OrderDetailModel.fromJson(responseRaw),
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
