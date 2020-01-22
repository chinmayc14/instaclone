import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram/models/user_data.dart';
import 'package:instagram/screens/activity.dart';
import 'package:instagram/screens/feedScreen.dart';
import 'package:instagram/screens/post.dart';
import 'package:instagram/screens/profile.dart';
import 'package:instagram/screens/search.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(
            currentUserId: currentUserId,
          ),
          SearchScreen(),
          PostScreen(),
          ActivityScreen(),
          ProfileScreen(
            userId: currentUserId,
            currentUserId: currentUserId,
          ),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.white,
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 100), curve: Curves.easeIn);
        },
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 32.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera, size: 32.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 32.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 32.0),
          ),
        ],
      ),
    );
  }
}
