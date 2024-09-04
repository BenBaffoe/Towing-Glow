import 'dart:convert';
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
  String mm = "mobile_money";
  String reference = 'TRX-${DateTime.now().millisecondsSinceEpoch}';
  String email = "benbaffoe@gmail.com";

  Future<PaystackAuthResponse> createTransaction(
      Transaction transaction) async {
    const String url = 'https://api.paystack.co/transaction/initialize';
    final data = transaction.toJson();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${ApiKey.secretkey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Print the full response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PaystackAuthResponse.fromJson(responseData['data']);
      } else {
        print('Payment unsuccessful: ${response.body}');
        throw "Payment unsuccessful";
      }
    } catch (e) {
      print('Payment failed: $e');
      throw "Payment failed: $e";
    }
  }

  Future<String?> initializeTransaction() async {
    try {
      final price = double.parse(amount);
      final transaction = Transaction(
        amount: (price * 100).toString(),
        reference: reference,
        currency: 'GHS',
        email: email,
        channels: ['card', 'mobile_money'],
      );
      final authResponse = await createTransaction(transaction);
      print('Authorization URL: ${authResponse.authorization_url}');
      return authResponse.authorization_url;
    } catch (e) {
      print('Error creating transaction: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: initializeTransaction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final url = snapshot.data!;
              print('URL: $url');
              if (Uri.tryParse(url)?.hasAbsolutePath ?? false) {
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
                      Uri.parse(url),
                    ),
                );
              } else {
                return Center(
                  child: Text('Invalid URL: $url'),
                );
              }
            } else {
              return Center(
                child: Text('No URL returned'),
              );
            }
          },
        ),
      ),
    );
  }
}
