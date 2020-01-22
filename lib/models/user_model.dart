import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileimgurl;
  final String email;
  final String bio;

  User({this.id, this.email, this.bio, this.name, this.profileimgurl});
  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
        id: doc.documentID,
        name: doc['name'],
        email: doc['email'],
        profileimgurl: doc['profileimgurl'],
        bio: doc['bio'] ?? '');
  }
}
