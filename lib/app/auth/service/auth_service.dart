import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qixer/app/auth/model/profile_model.dart';
import 'package:qixer/app/auth/model/user_model.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/shared/models/api_return_helper.dart';

class AuthService {
  static Future<ApiReturnValue> updateProfile(BuildContext context,
      {required String name,
      required String email,
      required String phone,
      required String cityId,
      required String areaId,
      required String postalCode,
      required String address,
      required String about,
      File? selectedFile}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/update-profile';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['name'] = name;
    requestVar.fields['email'] = email;
    requestVar.fields['phone'] = phone;
    requestVar.fields['service_city'] = cityId;
    requestVar.fields['service_area'] = areaId;
    requestVar.fields['country_id'] = '1';
    requestVar.fields['post_code'] = postalCode;
    requestVar.fields['address'] = address;
    requestVar.fields['about'] = about;
    requestVar.fields['country_code'] = 'Indonesia';

    if (selectedFile != null) {
      requestVar.files.add(await http.MultipartFile.fromPath(
          'file', selectedFile.path,
          filename: 'profileImage$name$address${selectedFile.path}}.jpg'));
    }

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

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

  static Future<ApiReturnValue> changePassword(
    BuildContext context, {
    required String passwordOld,
    required String newPassword,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/change-password';

    var requestVar = http.MultipartRequest('POST', Uri.parse(url));

    requestVar.fields['new_password'] = newPassword;
    requestVar.fields['current_password'] = passwordOld;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

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

  static Future<ApiReturnValue> register(
    BuildContext context, {
    required String name,
    required String email,
    required String username,
    required String phone,
    required String password,
    required String cityId,
    required String areaId,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/register';

    Map<String, String> dataBody = {};

    dataBody['name'] = name;
    dataBody['email'] = email;
    dataBody['username'] = username;
    dataBody['phone'] = phone;
    dataBody['password'] = password;
    dataBody['service_city'] = cityId;
    dataBody['service_area'] = areaId;
    dataBody['country_id'] = "1";
    dataBody['terms_conditions'] = "1";
    dataBody['country_code'] = "Indonesia";

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpPostRequest(
        context,
        dataBody: dataBody,
        url: url,
        exceptionStatusCode: [201],
        auth: false);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: User.fromJson(responseRaw),
          status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        Map<String, dynamic> datamessages = response.data['errors'];

        datamessages.forEach((key, value) {
          messages = value[0];
        });
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/login';

    Map<String, String> dataBody = {};

    dataBody['email'] = email;
    dataBody['password'] = password;
    dataBody['user_type'] = '1';

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpPostRequest(
        context,
        dataBody: dataBody,
        url: url,
        exceptionStatusCode: [201],
        auth: false);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: User.fromJson(responseRaw),
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

  static Future<ApiReturnValue> profile(BuildContext context,
      {required String token}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/profile';

    var requestVar = http.MultipartRequest('GET', Uri.parse(url));

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpRequest(
        context,
        request: requestVar,
        exceptionStatusCode: [201],
        customToken: 'Bearer $token',
        auth: true);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: ProfileModel.fromJson(responseRaw),
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

  static Future<ApiReturnValue> forgotPassword(
    BuildContext context, {
    required String phone,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/reset-new-password';

    Map<String, String> dataBody = {};

    dataBody['phone'] = phone;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpPostRequest(
        context,
        dataBody: dataBody,
        url: url,
        exceptionStatusCode: [201],
        auth: false);

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      if (responseRaw['type'] == 'success') {
        returnValue =
            ApiReturnValue(data: null, status: RequestStatus.successRequest);
      } else {
        String? messages;
        try {
          messages = response.data['msg'];
        } catch (e) {}
        returnValue =
            ApiReturnValue(data: messages, status: RequestStatus.failedRequest);
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

  static Future<ApiReturnValue> sendOTPPhone(BuildContext context,
      {required String phone, required String token}) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/send-otp';

    Map<String, String> dataBody = {};

    dataBody['phone'] = phone;

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpPostRequest(
      context,
      dataBody: dataBody,
      url: url,
      customToken: 'Bearer $token',
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: responseRaw['otp'], status: RequestStatus.successRequest);
    } else {
      String? messages;
      try {
        messages = response.data['message'];
      } catch (e) {}
      returnValue = ApiReturnValue(data: messages, status: response.status);
    }

    return returnValue;
  }

  static Future<ApiReturnValue> verifOTP(
    BuildContext context, {
    required User data,
  }) async {
    ApiReturnValue returnValue;

    String url = '$baseApi/user/send-otp/success';

    Map<String, String> dataBody = {};

    dataBody['user_id'] = data.id;
    dataBody['phone_verified'] = '1';

    ApiReturnValue<dynamic>? response = await ApiReturnValue.httpPostRequest(
      context,
      dataBody: dataBody,
      url: url,
      customToken: 'Bearer ${data.token}',
      auth: true,
      exceptionStatusCode: [201],
    );

    if (response!.status == RequestStatus.successRequest) {
      var responseRaw = response.data;

      returnValue = ApiReturnValue(
          data: responseRaw['otp'], status: RequestStatus.successRequest);
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
