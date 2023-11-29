import 'dart:convert';
import 'dart:io';
import 'package:gtecap/main.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gtecap/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AlterRViewDetails extends StatefulWidget {
  const AlterRViewDetails({Key? key}) : super(key: key);

  @override
  State<AlterRViewDetails> createState() => _AlterRViewDetailsState();
}

class _AlterRViewDetailsState extends State<AlterRViewDetails> {
  File? _imageFile1, _imageFile2, _imageFile3, _imageFile4, _imageFile5;
  String? selectedValue,
      brnCode,
      truck_code,
      user_id,
      acct_type,
      formattedDate,
      return_id,
      brncode_dest,
      transfer_brncode,
      received_brncode;

  List<Map<String, dynamic>> items = [];
  final _textController = TextEditingController();

  Future<File?> captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<void> uploadImage(File imageFile, String type) async {
    String imagePath = imageFile.path;
    List<String> pathParts = imagePath.split('/');
    String imageName = pathParts.last;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://clambagojbmgeos12435aqwdvcxwetv7543.com/Api/public/image-upload/do_upload?type=${type}&user_type=${user_id!}&brn_code=${brnCode!}&image=${imageName}&truck_code=${truck_code!}&date=${formattedDate!}&transfer_type=Received&return_id=${return_id!}'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      //  final responseData = json.decode(response.body);
      // final responseData = json.decode();
      print(response);
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image.');
    }
  }

  void _captureAndUploadImage1() async {
    final capturedImage = await captureImage();
    if (capturedImage != null) {
      setState(() {
        _imageFile1 = capturedImage;
      });
      // uploadImage(_imageFile1!);
    }
    return null;
  }

  void _captureAndUploadImage2() async {
    final capturedImage = await captureImage();
    if (capturedImage != null) {
      setState(() {
        _imageFile2 = capturedImage;
      });
      // uploadImage(_imageFile1!);
    }
    return null;
  }

  void _captureAndUploadImage3() async {
    final capturedImage = await captureImage();
    if (capturedImage != null) {
      setState(() {
        _imageFile3 = capturedImage;
      });
      // uploadImage(_imageFile1!);
    }
    return null;
  }

  void _captureAndUploadImage4() async {
    final capturedImage = await captureImage();
    if (capturedImage != null) {
      setState(() {
        _imageFile4 = capturedImage;
      });
      // uploadImage(_imageFile1!);
    }
    return null;
  }

  void _captureAndUploadImage5() async {
    final capturedImage = await captureImage();
    if (capturedImage != null) {
      setState(() {
        _imageFile5 = capturedImage;
      });
    }
    return null;
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      brnCode = prefs.getString('brn_code') ?? '';
      truck_code = prefs.getString('truck_code');

      acct_type = prefs.getString('user_position').toString();

      brncode_dest = prefs.getString('brnCode_dest').toString();

      transfer_brncode = prefs.getString('transfer_brncode').toString();

      received_brncode = prefs.getString('received_brncode').toString();

      // truck_code = "BSIT12345";

      DateTime now = DateTime.now();
      formattedDate = DateFormat('yyyy-MM-dd').format(now);
      print(formattedDate.toString());
      // brnCode = "SAMPLE";
      user_id = prefs.getString('user_id');
    });
  }

  void missingPicture() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'Missing Details!',
      desc: 'There is missing field is required.',
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  Future<void> changeLocation() async {
    final Uri url = Uri.https(
      'clambagojbmgeos12435aqwdvcxwetv7543.com',
      'Api/public/alter/received',
    );

    final Map<String, dynamic> requestBody = {
      'code': truck_code,
      'transfer_location': brnCode,
      'user_id': user_id,
      'remarks': _textController.text,
    };
    try {
      final response = await http.post(url, body: requestBody);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          // Navigate to the 'TransferTruck' screen on success.
          return_id = jsonResponse['return_id'];

          uploadImage(_imageFile1!, 'Front');
          uploadImage(_imageFile2!, 'Inside');
          uploadImage(_imageFile3!, 'Left');
          uploadImage(_imageFile4!, 'Right');
          uploadImage(_imageFile5!, 'Back');
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: 'Successfully Received!',
            desc: 'The truck has been successfully received.',
            btnOkOnPress: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Dashboard()),
              // );
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            headerAnimationLoop: false,
            animType: AnimType.bottomSlide,
            title: 'Unable to Received!',
            desc: 'Unable to receive the truck. Please try again later.',
            buttonsTextStyle: const TextStyle(color: Colors.black),
            // btnCancelOnPress: () {},
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ).show();
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request.
      print('Error: $e');
    }
  }

// this part of the code will check if there is already credential
  void _userDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_id')) {
      // change scene to dashboard
      // // ignore: use_build_context_synchronously
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Dashboard()),
      // );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _userDetails();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Received Truck',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Truck Code: ${truck_code}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Transfer by: ${transfer_brncode}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Transfer to: ${brncode_dest}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Received by: ${received_brncode}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Reason (required):',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: _textController,
                          maxLines: null, // Allows multiple lines of text
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       'New Location:',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.normal,
                    //         color: Color.fromARGB(255, 78, 78, 78),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(25, 5, 25, 15),
                    //   child: DropdownButton<String>(
                    //     value: selectedValue,
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         selectedValue = newValue;
                    //       });
                    //     },
                    //     isExpanded: true,
                    //     items: DropdownMenuItemBuilder.build(items),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (_imageFile1 != null)
                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 200, // Specify the desired width
                                  height: 200, // Specify the desired height
                                  child: Image.file(_imageFile1!),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _captureAndUploadImage1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Front',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (_imageFile2 != null)
                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 200, // Specify the desired width
                                  height: 200, // Specify the desired height
                                  child: Image.file(_imageFile2!),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _captureAndUploadImage2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Inside',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (_imageFile3 != null)
                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 200, // Specify the desired width
                                  height: 200, // Specify the desired height
                                  child: Image.file(_imageFile3!),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _captureAndUploadImage3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Left Side',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (_imageFile4 != null)
                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 200, // Specify the desired width
                                  height: 200, // Specify the desired height
                                  child: Image.file(_imageFile4!),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _captureAndUploadImage4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Right Side',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (_imageFile5 != null)
                          Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 200, // Specify the desired width
                                  height: 200, // Specify the desired height
                                  child: Image.file(_imageFile5!),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ElevatedButton(
                          onPressed: _captureAndUploadImage5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle cancel button press
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 245, 214, 76),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 20, 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if ((_textController.text != "") &&
                              (_imageFile1 != null) &&
                              (_imageFile2 != null) &&
                              (_imageFile3 != null) &&
                              (_imageFile4 != null) &&
                              (_imageFile5 != null)) {
                            changeLocation();
                          } else {
                            missingPicture();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 62, 238, 141),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Received',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalImageGallery extends StatelessWidget {
  final List<String> imageUrls = [
    'https://clambagojbmgeos12435aqwdvcxwetv7543.com/assets/trucks/65017a487fc03_1694595656.jpg',
    'https://clambagojbmgeos12435aqwdvcxwetv7543.com/assets/trucks/65017a487fc03_1694595656.jpg',
    'https://clambagojbmgeos12435aqwdvcxwetv7543.com/assets/trucks/65017a487fc03_1694595656.jpg',
    // Add more image URLs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10.0),
            width: 300,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrls[index],
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
