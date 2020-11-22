import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:slimy_card/slimy_card.dart';

// for camera

import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// http

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //image

  String predict='';

  File image;
  Future getImage(bool) async {
    File picture;
    if (bool) {
      // ignore: deprecated_member_use
      picture = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 300,
        maxHeight: 300,
      );
    } else {
      // ignore: deprecated_member_use
      picture = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    }

    setState(() {
      image = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Flutter",
            style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold),
          ),
          Text(
            "Math",
            style: TextStyle(
                color: Colors.blue,
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
          )
        ],
      )),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: SlimyCard(
                color: Colors.blue,
                topCardWidget: _topCard(image),
                bottomCardWidget: _bottomCard(predict),
              ),
            ),
            Container(
              height: 50,
              width: 100,
              child: RaisedButton(
                child: Text("Evaluate"),                
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                onPressed: () async {

                  Uri apiUrl = Uri.parse("http://adityayadav800.pythonanywhere.com/calc/");  //api url here
                  final imageUploadRequest =
                      http.MultipartRequest('POST', apiUrl);
                  final mimeTypeData =
                      lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])
                          .split('/');
                  final file = await http.MultipartFile.fromPath(
                      'image', image.path,
                      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
                  imageUploadRequest.files.add(file);
        
                  final streamedResponse = await imageUploadRequest.send();
                  final response =
                      await http.Response.fromStream(streamedResponse);
                  if (response.statusCode != 200) {
                    return null;
                  }
                  final responseData = json.decode(response.body);

                  setState(() {
                    predict = responseData['result'];
                  });



                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue,
        animatedIcon: AnimatedIcons.menu_close,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () {
                getImage(false);
              }),
          SpeedDialChild(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.camera,
                color: Colors.white,
              ),
              onTap: () {
                getImage(true);
              }),
        ],
      ),
    );
  }
}

Widget _topCard(File image) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: image == null
                ? Center(
                    child: Text(
                    "Upload Image Here",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
                : Image.file(image)),
      ],
    ),
  );
}

Widget _bottomCard(String predict) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text("Analysis"),
      Text(
       predict==""?"Your result":predict,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
