import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/auth_serv.dart';
import 'package:instagram/services/database_service.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feedScreen';
  final String currentUserId;
  FeedScreen({this.currentUserId});
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);
    setState(() {
      _posts = posts;
    });
  }

  _buildPost(Post post, User author) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.grey,
                backgroundImage: author.profileimgurl.isEmpty
                    ? AssetImage('assets/images/user_profile.png')
                    : CachedNetworkImageProvider(author.profileimgurl),
              ),
              SizedBox(
                width: 8.0,
              ),
              Text(
                author.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Instagram',
            style: TextStyle(
                fontFamily: 'Billabong', fontSize: 35.0, color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index) {
          Post post = _posts[index];
          return FutureBuilder(
            future: DatabaseService.getUserWithID(post.authorId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }
              User author = snapshot.data;
              return _buildPost(post, author);
            },
          );
        },
      ),
    );
  }
}
