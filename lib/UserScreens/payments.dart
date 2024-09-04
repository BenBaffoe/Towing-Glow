import 'package:firebase_database/firebase_database.dart';

class Transaction {
  final String amount;
  final String reference;
  final String email;
  final String currency;
  final List<String> channels;

  Transaction({
    required this.amount,
    required this.reference,
    required this.email,
    required this.currency,
    required this.channels,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'],
      reference: json['reference'],
      currency: json['currency'],
      email: json['email'],
      channels: List<String>.from(json['channels']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'reference': reference,
      'currency': currency,
      'email': email,
      'channels': channels,
    };
  }
}
