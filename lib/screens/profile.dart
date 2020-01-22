import 'package:flutter/material.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/database_service.dart';
import 'package:instagram/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'edit_Prof_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram/models/user_data.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String userId;
  ProfileScreen({this.userId, this.currentUserId});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int followingCount = 0;
  int followerCount = 0;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing() async {
    bool _isfollowingUser = await DatabaseService.isfollowingUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = _isfollowingUser;
    });
  }

  _setupFollowers() async {
    int userfollowerCount = await DatabaseService.numFollowers(widget.userId);

    setState(() {
      followerCount = userfollowerCount;
    });
  }

  _setupFollowing() async {
    int userfollowingCount = await DatabaseService.numFollowing(widget.userId);

    setState(() {
      followingCount = userfollowingCount;
    });
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollow();
    } else {
      _follow();
    }
  }

  _unfollow() {
    DatabaseService.unfollowUser(widget.currentUserId, widget.userId);
    setState(() {
      _isFollowing = false;
      followerCount--;
    });
  }

  _follow() {
    DatabaseService.followUser(widget.currentUserId, widget.userId);
    setState(() {
      _isFollowing = true;
      followerCount++;
    });
  }

  _displayButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: 160.0,
              height: 40.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: FlatButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProf(user: user),
                  ),
                ),
                child: Text('Edit Profile'),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: 160.0,
              height: 40.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: FlatButton(
                onPressed: _followOrUnfollow,
                color: _isFollowing ? Colors.grey[200] : Colors.lightBlueAccent,
                textColor: _isFollowing ? Colors.black : Colors.white,
                child: Text(_isFollowing ? 'Unfollow' : 'Follow'),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'PUBG social',
            style: TextStyle(
                fontFamily: 'Billabong', fontSize: 35.0, color: Colors.white),
          ),
        ),
      ),
      body: FutureBuilder(
        future: userref.document(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 20.0, bottom: 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.white,
                        backgroundImage: user.profileimgurl.isEmpty
                            ? AssetImage('assets/images/user_profile.png')
                            : CachedNetworkImageProvider(user.profileimgurl)),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '12',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followerCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    followingCount.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          _displayButton(user),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 80.0,
                      child: Text(
                        user.bio,
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.2,
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }
}
