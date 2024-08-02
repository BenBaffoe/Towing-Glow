import 'dart:convert';

// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/payments.dart';
import 'package:onroadvehiclebreakdowwn/models/paystack/paystack_auth_response.dart';
import 'package:onroadvehiclebreakdowwn/models/paystackapi.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class Paymentscreen extends StatefulWidget {
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  String amount = "50";
  String reference = "Amount at the end ";
  String email = "benbaffoe@gmail.com";
  //function for creating transaction

  Future<PaystackAuthResponse> createTransaction(
      Transaction transaction) async {
    const String url = 'https://api.payment.co/transaction/intialize';
    final data = transaction.toJson();

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${ApiKey.secretkey}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PaystackAuthResponse.fromJson(responseData['data']);
      } else {
        throw "Payment unsuccessful";
      }
    } on Exception {
      throw "Payment failed";
    }
  }

  Future<String> initializeTransaction() async {
    try {
      final price = double.parse(amount);
      final transaction = Transaction(
        amount: (price * 100).toString(),
        reference: reference,
        currency: 'GHS',
        email: email,
      );
      final authResponse = await createTransaction(transaction);
      return authResponse.authorization_url;
    } catch (e) {
      print('Error creating transaction : $e');
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: initializeTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final url = snapshot.data;
                  return WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..setBackgroundColor(const Color(0x00000000))
                      ..setNavigationDelegate(
                        NavigationDelegate(
                          onProgress: (int progress) {
                            // Update loading bar.
                          },
                          onPageStarted: (String url) {},
                          onPageFinished: (String url) {},
                          onHttpError: (HttpResponseError error) {},
                          onWebResourceError: (WebResourceError error) {},
                          onNavigationRequest: (NavigationRequest request) {
                            if (request.url
                                .startsWith('https://www.youtube.com/')) {
                              return NavigationDecision.prevent;
                            }
                            return NavigationDecision.navigate;
                          },
                        ),
                      )
                      ..loadRequest(
                        Uri.parse(url!),
                      ),
                  );
                } else {
                  return const CircularProgressIndicator(
                    strokeWidth: 2,
                  );
                }
              })),
    );
  }
}
