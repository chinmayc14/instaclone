import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imgurl;
  final String caption;
  final dynamic likes;
  final String authorId;
  final Timestamp timestamp;

  Post(
      {this.id,
      this.timestamp,
      this.authorId,
      this.caption,
      this.imgurl,
      this.likes});

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      imgurl: doc['imgurl'],
      caption: doc['caption'],
      likes: doc['likes'],
      authorId: doc['authoId'],
      timestamp: doc['timestamp'],
    );
  }
}
