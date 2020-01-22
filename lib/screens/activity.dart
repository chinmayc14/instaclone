import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
