// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService with ChangeNotifier {
  bool pusherCredentialLoaded = false;

  //
  sendNotificationToSeller(BuildContext context,
      {required sellerId, required title, required body}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection('notif_token').doc('seller_$sellerId').get();
    if (doc.exists) {
      String token = doc.data()!['token'];

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        // "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAXt0NRNM:APA91bGAxshnPxgRgQDjphlUoNi_qtqg8_X81lc8MpuJWbXsowX_4XLeMS7Gdpf5hdfqvzGBj-sH11nRN1pU50nzSzruCYL1ae5auOltJLlKkcGgiGKVjcJJXYRkz-B_HSB40GnjZvDF",
      };

      var data = jsonEncode({
        "to": token,
        "notification": {"body": body, "title": title}
      });

      var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: header,
          body: data);

      print(token);
    }

    // var pUrl = Provider.of<PushNotificationService>(context, listen: false)
    //     .pusherApiUrl;

    // var pToken = Provider.of<PushNotificationService>(context, listen: false)
    //     .pusherToken;

    // if (response.statusCode == 200) {
    //   print('send notification to seller success');
    // } else {
    //   print('send notification to seller failed');
    //   print(response.body);
    // }
  }

  sendNotificationToSellerByToken(BuildContext context,
      {required String? token, required title, required body}) async {
    if (token != null) {
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        // "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAXt0NRNM:APA91bGAxshnPxgRgQDjphlUoNi_qtqg8_X81lc8MpuJWbXsowX_4XLeMS7Gdpf5hdfqvzGBj-sH11nRN1pU50nzSzruCYL1ae5auOltJLlKkcGgiGKVjcJJXYRkz-B_HSB40GnjZvDF",
      };

      var data = jsonEncode({
        "to": token,
        "notification": {"body": body, "title": title}
      });

      var response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: header,
          body: data);
    }

    //get pusher credential
    //======================>

    var apiKey;
    var secret;
    var pusherToken;
    var pusherApiUrl;
    var pusherCluster;
    var pusherInstance;

    Future<bool> fetchPusherCredential({context}) async {
      if (pusherCredentialLoaded == true) return false;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };

      var response = await http.get(
          Uri.parse("$baseApi/user/chat/pusher/credentials"),
          headers: header);

      print(response.body);

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        pusherCredentialLoaded = true;
        apiKey = jsonData['pusher_app_key'];
        secret = jsonData['pusher_app_secret'];
        pusherToken = jsonData['pusher_app_push_notification_auth_token'];
        pusherApiUrl = jsonData['pusher_app_push_notification_auth_url'];
        pusherCluster = jsonData['pusher_app_cluster'];
        pusherInstance = jsonData['pusher_app_push_notification_instanceId'];

        notifyListeners();
        return true;
      } else {
        print(response.body);
        return false;
      }
    }
  }
}
