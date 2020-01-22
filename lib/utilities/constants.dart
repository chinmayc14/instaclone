import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;

final userref = _firestore.collection('users');

final storageref = FirebaseStorage.instance.ref();

final postsref = _firestore.collection('posts');

final followersref = _firestore.collection('followers');

final followingref = _firestore.collection('following');

final feedRef = _firestore.collection('feeds');
