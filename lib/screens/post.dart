import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:instagram/services/database_service.dart';
import 'package:instagram/services/storage_service.dart';
import 'package:instagram/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user_data.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  _showselectimage() {
    return Platform.isIOS ? _androidDialog() : _iosBottomSheet();
  }

  File _imageFile;
  TextEditingController _captionController = TextEditingController();
  String _caption = '';
  bool _isloading = false;
  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose From Gallery'),
                onPressed: () => _handleImage(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cnacel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _handleImage(ImageSource source) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    return croppedImage;
  }

  _submit() async {
    if (!_isloading && _imageFile != null && _caption.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      //create
      String imgurl = await StorageService.uploadpost(_imageFile);
      Post post = Post(
        imgurl: imgurl,
        caption: _caption,
        likes: {},
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createPost(post);

      //reset
      _captionController.clear();
      setState(() {
        _caption = '';
        _imageFile = null;
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Create Posts',
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: _submit,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                _isloading
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red[200],
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: _showselectimage,
                  child: Container(
                    height: width,
                    width: width,
                    color: Colors.black87,
                    child: _imageFile == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.white70,
                            size: 120,
                          )
                        : Image(
                            image: FileImage(_imageFile),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                        labelText: 'Add a Caption',
                        prefixIcon: Icon(Icons.library_books)),
                    onChanged: (input) => _caption = input,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
