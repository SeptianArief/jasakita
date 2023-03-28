import 'dart:async';
import 'dart:io';

import 'package:qixer/app/order/pages/payment_success_page.dart';
import 'package:qixer/shared/const_helper.dart';
import 'package:qixer/shared/form_helper.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPaymentWebview extends StatefulWidget {
  final String url;
  final String tanggal;
  final String jadwal;
  final String tax;
  final double taxPrice;
  final double totalPackage;
  final double subtotal;
  final double extraCharge;
  final double total;
  final bool isFromOrder;
  const UserPaymentWebview(
      {Key? key,
      required this.url,
      required this.tanggal,
      required this.jadwal,
      required this.tax,
      this.isFromOrder = false,
      required this.taxPrice,
      required this.totalPackage,
      required this.subtotal,
      required this.extraCharge,
      required this.total})
      : super(key: key);

  @override
  State<UserPaymentWebview> createState() => _UserPaymentWebviewState();
}

class _UserPaymentWebviewState extends State<UserPaymentWebview> {
  final Completer<wv.WebViewController> _controller =
      Completer<wv.WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) wv.WebView.platform = wv.AndroidWebView();
  }

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          FormHelper.showSnackbar(context,
              data: 'Tekan sekali lagi untuk keluar dari halaman pembayaran',
              colors: Colors.black);

          return Future.value(false);
        }
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
            body: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lakukan Pembayaran',
                        style: mainFont.copyWith(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close, color: Colors.black87),
                    )
                  ])),
          Expanded(
              child: wv.WebView(
            initialUrl: widget.url,
            javascriptMode: wv.JavascriptMode.unrestricted,
            onWebViewCreated: (wv.WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <wv.JavascriptChannel>[].toSet(),
            onPageFinished: (value) async {
              if (value.contains('xendit-payment/success') ||
                  value.contains('xendit-success') ||
                  value.contains('xendit-payment/nextSuccess')) {
                http.get(Uri.parse(value));
                FormHelper.showSnackbar(context,
                    data: 'Pembayaran Berhasil', colors: Colors.green);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentSuccessPage(
                              paymentStatus: 'Success',
                              extraCharge: widget.extraCharge,
                              jadwal: widget.jadwal,
                              subtotal: widget.subtotal,
                              tanggal: widget.tanggal,
                              tax: widget.tax,
                              taxPrice: widget.taxPrice,
                              total: widget.total,
                              totalPackage: widget.totalPackage,
                            )));
              }
            },
          ))
        ])),
      ),
    );
  }
}
