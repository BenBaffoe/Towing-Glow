class Paymodel {
  String? name;
  String? phone;
  String? time;
  String? amount;
  String? service;

  Paymodel({
    required this.name,
    required this.phone,
    this.amount,
    this.time,
    required this.service,
  });
}
