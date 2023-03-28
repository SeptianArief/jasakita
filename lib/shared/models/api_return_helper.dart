// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/app/auth/cubits/auth_cubit.dart';
import 'package:qixer/app/auth/cubits/auth_state.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiReturnValue<T> {
  T data;
  RequestStatus status;

  ApiReturnValue({required this.data, required this.status});

  static Future<ApiReturnValue<dynamic>?> httpPutRequest(BuildContext context,
      {required String url,
      required Map<String, dynamic> jsonMap,
      List<int>? exceptionStatusCode,
      bool? auth}) async {
    ApiReturnValue<dynamic>? returnValue;
    bool authHeader = auth ?? true;
    Map<String, String> headersMap = {};

    if (authHeader) {
      final storage = await SharedPreferences.getInstance();
      String? token = storage.getString('token');

      if (token != null) {
        headersMap['Authorization'] = token;
      }
    }

    headersMap['Content-Type'] = 'application/json';

    print(" PUT Request to:");
    print(url);
    print('Header : $headersMap');
    print('Body : $jsonMap ');

    print('----------------------------------------------------');

    // try {
    final response = await http.put(Uri.parse(url),
        body: json.encode(jsonMap), headers: headersMap);
    var data = json.decode(response.body);
    print(response.statusCode);
    print(data);

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        returnValue =
            ApiReturnValue(data: null, status: RequestStatus.failedRequest);
        BlocProvider.of<UserCubit>(context).logout(context);
        FormHelper.showSnackbar(
          context,
          colors: Colors.orange,
          data: 'Sesi Habis, Mohon Login Kembali',
        );
      } else if (exceptionStatusCode != null) {
        if (exceptionStatusCode.contains(response.statusCode)) {
          returnValue =
              ApiReturnValue(status: RequestStatus.successRequest, data: data);
        } else {
          returnValue =
              ApiReturnValue(data: data, status: RequestStatus.failedRequest);
        }
      } else {
        returnValue =
            ApiReturnValue(data: data, status: RequestStatus.failedRequest);
      }
    } else {
      returnValue =
          ApiReturnValue(status: RequestStatus.successRequest, data: data);
    }
    // } on SocketException {
    //   returnValue =
    //       ApiReturnValue(data: null, status: RequestStatus.internetIssue);
    // } catch (e) {
    //   print(e);
    //   returnValue =
    //       ApiReturnValue(status: RequestStatus.serverError, data: null);
    // }

    return returnValue;
  }

  static Future<ApiReturnValue<dynamic>?> httpRequest(BuildContext context,
      {required http.MultipartRequest request,
      List<int>? exceptionStatusCode,
      String? customToken,
      bool? auth}) async {
    ApiReturnValue<dynamic>? returnValue;
    bool authHeader = auth ?? true;

    if (authHeader) {
      final storage = await SharedPreferences.getInstance();
      UserState userState = BlocProvider.of<UserCubit>(context).state;
      if (userState is UserLogged) {
        request.headers['Authorization'] =
            customToken ?? 'Bearer ${userState.user.token}';
      }
    }

    print(request.method + " Request to:");
    print(request.url);
    print('Header : ${request.headers}');
    print('Body : ${request.fields} ');

    print('----------------------------------------------------');

    try {
      final streamSend = await request.send();
      final response = await http.Response.fromStream(streamSend);
      var data = json.decode(response.body);
      print(response.statusCode);
      print(data);

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          returnValue =
              ApiReturnValue(data: null, status: RequestStatus.failedRequest);
          BlocProvider.of<UserCubit>(context).logout(context);
          FormHelper.showSnackbar(
            context,
            colors: Colors.orange,
            data: 'Sesi Habis, Mohon Login Kembali',
          );
        } else if (exceptionStatusCode != null) {
          if (exceptionStatusCode.contains(response.statusCode)) {
            returnValue = ApiReturnValue(
                status: RequestStatus.successRequest, data: data);
          } else {
            returnValue =
                ApiReturnValue(data: data, status: RequestStatus.failedRequest);
          }
        } else {
          returnValue =
              ApiReturnValue(data: data, status: RequestStatus.failedRequest);
        }
      } else {
        returnValue =
            ApiReturnValue(status: RequestStatus.successRequest, data: data);
      }
    } on SocketException {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.internetIssue);
    } catch (e) {
      print(e);
      returnValue =
          ApiReturnValue(status: RequestStatus.serverError, data: null);
    }

    return returnValue;
  }

  static Future<ApiReturnValue<dynamic>?> httpRequestHelper(
      BuildContext context,
      {required http.MultipartRequest request,
      List<int>? exceptionStatusCode,
      bool? auth}) async {
    ApiReturnValue<dynamic>? returnValue;
    bool authHeader = auth ?? true;

    if (authHeader) {
      final storage = await SharedPreferences.getInstance();
      String? token = storage.getString('token');

      if (token != null) {
        request.headers['Authorization'] = token;
      }
    }

    print(request.method + " Request to:");
    print(request.url);
    print('Header : ${request.headers}');
    print('Body : ${request.fields} ');

    print('----------------------------------------------------');

    try {
      final streamSend = await request.send();
      final response = await http.Response.fromStream(streamSend);
      var data = json.decode(response.body);
      print(response.statusCode);
      print(data);

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          returnValue =
              ApiReturnValue(data: null, status: RequestStatus.failedRequest);
          BlocProvider.of<UserCubit>(context).logout(context);
          FormHelper.showSnackbar(
            context,
            colors: Colors.orange,
            data: 'Sesi Habis, Mohon Login Kembali',
          );
        } else if (exceptionStatusCode != null) {
          if (exceptionStatusCode.contains(response.statusCode)) {
            returnValue = ApiReturnValue(
                status: RequestStatus.successRequest, data: data);
          } else {
            returnValue =
                ApiReturnValue(data: data, status: RequestStatus.failedRequest);
          }
        } else {
          returnValue =
              ApiReturnValue(data: data, status: RequestStatus.failedRequest);
        }
      } else {
        returnValue =
            ApiReturnValue(status: RequestStatus.successRequest, data: data);
      }
    } on SocketException {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.internetIssue);
    } catch (e) {
      print(e);
      returnValue =
          ApiReturnValue(status: RequestStatus.serverError, data: null);
    }

    return returnValue;
  }

  static Future<ApiReturnValue<dynamic>?> httpPostRequest(BuildContext context,
      {required Object dataBody,
      required String url,
      List<int>? exceptionStatusCode,
      Map<String, String>? dataHeader,
      String? customToken,
      bool? auth}) async {
    ApiReturnValue<dynamic>? returnValue;
    bool authHeader = auth ?? true;

    Map<String, String> headerMap = dataHeader ??
        {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        };

    if (authHeader) {
      if (customToken != null) {
        headerMap['Authorization'] = customToken;
      } else {
        final storage = await SharedPreferences.getInstance();
        String? token = storage.getString('token');

        if (token != null) {
          headerMap['Authorization'] = 'Bearer ' + token;
        }
      }
    }

    print("POST Request to:");
    print(url);
    print('Header : $headerMap');
    log('Body : $dataBody ');

    print('----------------------------------------------------');

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(dataBody), headers: headerMap);
      var data = json.decode(response.body);
      print(response.statusCode);
      print(data);

      if (response.statusCode != 200) {
        if (response.statusCode == 401 &&
            (exceptionStatusCode == null ||
                !exceptionStatusCode.contains(401))) {
          returnValue =
              ApiReturnValue(data: null, status: RequestStatus.failedRequest);
          BlocProvider.of<UserCubit>(context).logout(context);
          FormHelper.showSnackbar(
            context,
            colors: Colors.orange,
            data: 'Sesi Habis, Mohon Login Kembali',
          );
        } else if (exceptionStatusCode != null) {
          if (exceptionStatusCode.contains(response.statusCode)) {
            returnValue = ApiReturnValue(
                status: RequestStatus.successRequest, data: data);
          } else {
            returnValue =
                ApiReturnValue(data: data, status: RequestStatus.failedRequest);
          }
        } else {
          returnValue =
              ApiReturnValue(data: data, status: RequestStatus.failedRequest);
        }
      } else {
        returnValue =
            ApiReturnValue(status: RequestStatus.successRequest, data: data);
      }
    } on SocketException {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.internetIssue);
    } catch (e) {
      print(e);
      returnValue =
          ApiReturnValue(status: RequestStatus.serverError, data: null);
    }

    return returnValue;
  }

  static Future<ApiReturnValue<dynamic>?> httpDeleteRequest(
      BuildContext context,
      {required String url,
      List<int>? exceptionStatusCode,
      bool? auth}) async {
    ApiReturnValue<dynamic>? returnValue;
    bool authHeader = auth ?? true;

    Map<String, String> headerMap = {};

    if (authHeader) {
      final storage = await SharedPreferences.getInstance();
      String? token = storage.getString('token');

      if (token != null) {
        headerMap['Authorization'] = token;
      }
    }

    print("DELETE Request to:");
    print(url);
    print('Header : $headerMap');

    print('----------------------------------------------------');

    try {
      final response = await http.delete(Uri.parse(url), headers: headerMap);
      var data = json.decode(response.body);
      print(response.statusCode);
      print(data);

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          returnValue =
              ApiReturnValue(data: null, status: RequestStatus.failedRequest);
          BlocProvider.of<UserCubit>(context).logout(context);
          FormHelper.showSnackbar(
            context,
            colors: Colors.orange,
            data: 'Sesi Habis, Mohon Login Kembali',
          );
        } else if (exceptionStatusCode != null) {
          if (exceptionStatusCode.contains(response.statusCode)) {
            returnValue = ApiReturnValue(
                status: RequestStatus.successRequest, data: data);
          } else {
            returnValue =
                ApiReturnValue(data: data, status: RequestStatus.failedRequest);
          }
        } else {
          returnValue =
              ApiReturnValue(data: data, status: RequestStatus.failedRequest);
        }
      } else {
        returnValue =
            ApiReturnValue(status: RequestStatus.successRequest, data: data);
      }
    } on SocketException {
      returnValue =
          ApiReturnValue(data: null, status: RequestStatus.internetIssue);
    } catch (e) {
      print(e);
      returnValue =
          ApiReturnValue(status: RequestStatus.serverError, data: null);
    }

    return returnValue;
  }
}

enum RequestStatus {
  successRequest,
  failedRequest,
  failedParsing,
  serverError,
  internetIssue
}
