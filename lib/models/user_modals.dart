import 'package:firebase_auth/firebase_auth.dart';
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

  static Future<UserModel?> getCurrentUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("userInfo");

    DataSnapshot snapshot = await userRef.child(currentUser.uid).get();
    if (snapshot.exists) {
      return UserModel.fromSnapshot(snapshot);
    } else {
      return null;
    }
  }
}
