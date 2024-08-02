class PaystackAuthResponse {
  final String authorization_url;
  final String access_code;
  final String reference;

  PaystackAuthResponse({
    required this.access_code,
    required this.authorization_url,
    required this.reference,
  });

  factory PaystackAuthResponse.fromJson(Map<String, dynamic> json) {
    return PaystackAuthResponse(
      authorization_url: json['authorization_url'],
      access_code: json['access_code'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorization_url': authorization_url,
      'access_code': access_code,
      'reference': reference,
    };
  }
}
