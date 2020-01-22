import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/database_service.dart';
import 'dart:io';

import 'package:instagram/services/storage_service.dart';

class EditProf extends StatefulWidget {
  final User user;

  EditProf({this.user});
  @override
  _EditProfState createState() => _EditProfState();
}

class _EditProfState extends State<EditProf> {
  final _formkey = GlobalKey<FormState>();
  String _name = '', _bio = '';
  bool _isloading = false;
  File _profileImage;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _handleImageFromGallery() async {
    File imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imagefile != null) {
      setState(() {
        _profileImage = imagefile;
      });
    }
  }

  _displayProfImage() {
    if (_profileImage == null) {
      if (widget.user.profileimgurl.isEmpty) {
        return AssetImage('assets/images/user_placegolder.png');
      } else {
        return CachedNetworkImageProvider(widget.user.profileimgurl);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    if (_formkey.currentState.validate() && !_isloading) {
      _formkey.currentState.save();
      String _profileimgurl = '';

      setState(() {
        _isloading = true;
      });

      if (_profileimgurl == null) {
        _profileimgurl = widget.user.profileimgurl;
      } else {
        _profileimgurl = await StorageService.uploadUserProfile(
            widget.user.profileimgurl, _profileImage);
      }

      User user = User(
          id: widget.user.id,
          name: _name,
          bio: _bio,
          profileimgurl: _profileimgurl);
      DatabaseService.UpdateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('Edit Profile')),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            _isloading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.red[200],
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      backgroundImage: _displayProfImage(),
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Edit Profile Image',
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        labelText: 'Name',
                      ),
                      validator: (input) =>
                          input.trim().length < 1 ? 'Enter a valid Name' : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.speaker_notes,
                          size: 30.0,
                        ),
                        labelText: 'Bio',
                      ),
                      validator: (input) => input.trim().length > 150
                          ? 'Enter a Short Bio'
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Container(
                        width: 200.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.deepPurpleAccent, Colors.black],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                        child: FlatButton(
                          onPressed: _submit,
                          child: Text(
                            'Save',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
