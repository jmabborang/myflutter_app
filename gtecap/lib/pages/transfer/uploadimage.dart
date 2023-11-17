import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  @override
  UploadImageState createState() => UploadImageState();
}

class UploadImageState extends State<UploadImage> {
  File? _imageFile;

  Future<File?> captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<void> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.100.26/ci4test/public/image-upload/do_upload'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image.');
    }
  }

  void _captureAndUploadImage() async {
    final capturedImage = await captureImage();
    if (capturedImage != null) {
      setState(() {
        _imageFile = capturedImage;
      });
      uploadImage(_imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Capture and Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null) Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureAndUploadImage,
              child: Text('Capture and Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
