import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/screens/feedScreen.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user_data.dart';

class authServ {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;
  static void SignupUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser signedinUser = authResult.user;
      if (signedinUser != null) {
        _firestore.collection('/users').document(signedinUser.uid).setData({
          'name': name,
          'email': email,
          'profileimgurl': '',
        });
        Provider.of<UserData>(context).currentUserId = signedinUser.uid;
        Navigator.pushReplacementNamed(context, FeedScreen.id);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout(BuildContext context) {
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
