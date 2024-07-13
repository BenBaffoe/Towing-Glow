import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.id,
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
    name = (snap.value as dynamic)["name"];
  }
}
