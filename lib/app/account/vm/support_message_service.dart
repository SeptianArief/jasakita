import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:qixer/app/account/models/ticket_message_model.dart';
import 'package:qixer/app/auth/cubits/profile_cubit.dart';
import 'package:qixer/app/auth/cubits/profile_state.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:qixer/shared/push_notif_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportMessagesService with ChangeNotifier {
  List messagesList = [];

  bool isloading = false;
  bool sendLoading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  setSendLoadingTrue() {
    sendLoading = true;
    notifyListeners();
  }

  setSendLoadingFalse() {
    sendLoading = false;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();
  Future pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  fetchMessages(ticketId) async {
    messagesList = [];
    setLoadingTrue();
    //if connection is ok

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };
    var response = await http
        .get(Uri.parse('$baseApi/user/view-ticket/$ticketId'), headers: header);
    setLoadingFalse();

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['all_messages'].isNotEmpty) {
      var data = TicketMessageModel.fromJson(jsonDecode(response.body));

      setMessageList(data.allMessages);

      notifyListeners();
    } else {
      //Something went wrong
      print(response.body);
    }
  }

  setMessageList(dataList) {
    for (int i = 0; i < dataList.length; i++) {
      messagesList.add({
        'id': dataList[i].id,
        'message': dataList[i].message,
        'notify': 'off',
        'attachment': dataList[i].attachment,
        'type': dataList[i].type,
        'imagePicked':
            false //check if this image is just got picked from device in that case we will show it from device location
      });
    }
    notifyListeners();
  }

//Send new message ======>

  sendMessage(BuildContext context, ticketId, message, imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    FormData formData;
    if (imagePath != null) {
      formData = FormData.fromMap({
        'ticket_id': ticketId,
        'user_type': 'buyer',
        'message': message,
        'file': await MultipartFile.fromFile(imagePath,
            filename: 'ticket$imagePath.jpg')
      });
    } else {
      formData = FormData.fromMap({
        'ticket_id': ticketId,
        'user_type': 'buyer',
        'message': message,
      });
    }

    setSendLoadingTrue();
    //if connection is ok

    var response = await dio.post(
      '$baseApi/user/ticket/message-send',
      data: formData,
    );
    setSendLoadingFalse();

    if (response.statusCode == 201) {
      print(response.data);
      addNewMessage(message, imagePath);
      return true;
    } else {
      FormHelper.showSnackbar(context,
          colors: Colors.orange, data: 'Terjadi kesalahan');
      print(response.data);
      return false;
    }
  }

  addNewMessage(newMessage, imagePath) {
    messagesList.add({
      'id': '',
      'message': newMessage,
      'notify': 'off',
      'attachment': imagePath,
      'type': 'buyer',
      'imagePicked':
          true //check if this image is just got picked from device in that case we will show it from device location
    });
    notifyListeners();
  }

  //
  sendNotification(BuildContext context, {required sellerId, required msg}) {
    ProfileState state = BlocProvider.of<ProfileCubit>(context).state;
    if (state is ProfileLoaded) {
      PushNotificationService().sendNotificationToSeller(context,
          sellerId: sellerId,
          title: "New message from support: ${state.data.detail.name}",
          body: '$msg');
    }
  }
}
