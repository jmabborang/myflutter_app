import 'dart:convert';
import 'dart:io';
import 'package:gtecap/main.dart';
import 'package:gtecap/pages/dashboard.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TViewDetails extends StatefulWidget {
  const TViewDetails({Key? key}) : super(key: key);

  @override
  State<TViewDetails> createState() => _TViewDetailsState();
}

class DropdownMenuItemBuilder {
  static List<DropdownMenuItem<String>> build(
      List<Map<String, dynamic>> items) {
    return items.map<DropdownMenuItem<String>>(
      (Map<String, dynamic> item) {
        return DropdownMenuItem<String>(
          value: item["brn_code"].toString(),
          child: Text(item["brn_name"].toString()),
        );
      },
    ).toList();
  }
}

class _TViewDetailsState extends State<TViewDetails> {
  File? _imageFile1, _imageFile2, _imageFile3, _imageFile4, _imageFile5;
  String? selectedValue, brnCode, truck_code, user_id, acct_type, formattedDate;
  List<Map<String, dynamic>> items = [];
  final _textController = TextEditingController();
  final _drivertextController = TextEditingController();
  final _driverContacttextController = TextEditingController();

  // this variables is for truck Details
  String? title,
      truck_location,
      brand,
      category,
      vehicle_type,
      chassis_series,
      chassis_type,
      chassis_num,
      year_model,
      front_panel,
      cabin_type,
      cabin_height,
      chrome_type,
      transmission,
      cabchassis_differential,
      registered_name,
      plate_num;

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
          'https://clambagojbmgeos12435aqwdvcxwetv7543.com/Api/public/image-upload/do_upload?type=${type!}&user_type=${user_id!}&brn_code=${brnCode!}&image=${imageName}&truck_code=${truck_code!}&date=${formattedDate!}&transfer_type=Transfer'),
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

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('driver_name');
      prefs.remove('contact_number');
      brnCode = prefs.getString('brn_code') ?? '';
      truck_code = prefs.getString('truck_code');

      acct_type = prefs.getString('user_position').toString();

      // truck_code = "BSIT12345";

      DateTime now = DateTime.now();
      formattedDate = DateFormat('yyyy-MM-dd').format(now);
      print(formattedDate.toString());
      // brnCode = "SAMPLE";
      user_id = prefs.getString('user_id');
    });
    var url = Uri.https(
        'clambagojbmgeos12435aqwdvcxwetv7543.com',
        '/Api/public/branch-available/',
        {'q': brnCode, 'user_type': acct_type, 'truck_code': truck_code});
    print(url.toString());
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      setState(() {
        title = prefs.getString('title').toString();
        truck_location = prefs.getString('truck_location').toString();
        brand = prefs.getString('truck_brand').toString();
        category = prefs.getString('truck_category').toString();
        vehicle_type = prefs.getString('vehicle_type').toString();
        chassis_series = prefs.getString('chassis_series').toString();
        chassis_type = prefs.getString('chassis_type').toString();
        chassis_num = prefs.getString('chassis_num').toString();
        year_model = prefs.getString('year_model').toString();
        front_panel = prefs.getString('front_panel').toString();
        cabin_type = prefs.getString('cabin_type').toString();
        cabin_height = prefs.getString('cabin_height').toString();
        chrome_type = prefs.getString('chrome_type').toString();
        transmission = prefs.getString('transmission').toString();
        cabchassis_differential =
            prefs.getString('cabchassis_differential').toString();
        registered_name = prefs.getString('registered_name').toString();
        plate_num = prefs.getString('plate_num').toString();

        items = List<Map<String, dynamic>>.from(jsonResponse['data']);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
      'Api/public/transfer',
    );

    final Map<String, dynamic> requestBody = {
      'code': truck_code,
      'transfer_location': selectedValue,
      'user_id': user_id,
      'contact_numb': _driverContacttextController.text,
      'driver_name': _drivertextController.text,
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
          // ignore: use_build_context_synchronously

          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: 'Successfully Transfer!',
            desc: 'Waiting to receive truck on the other branch.',
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show();
          uploadImage(_imageFile1!, 'Front');
          uploadImage(_imageFile2!, 'Inside');
          uploadImage(_imageFile3!, 'Left');
          uploadImage(_imageFile4!, 'Right');
          uploadImage(_imageFile5!, 'Back');
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            headerAnimationLoop: false,
            animType: AnimType.bottomSlide,
            title: 'Request Exist!',
            desc: 'There is already transfer request for this truck',
            buttonsTextStyle: const TextStyle(color: Colors.black),
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          ).show();
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          headerAnimationLoop: false,
          title: 'Error',
          desc:
              'Dialog description here..................................................',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red,
        ).show();
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request.
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _userDetails();
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
              // Text(truck_code!),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Truck Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
              // HorizontalImageGallery(), // Display the image gallery

              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Driver's Name:",
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
                          controller: _drivertextController,
                          maxLines: null, // Allows multiple lines of text
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contact Number:",
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
                          controller: _driverContacttextController,
                          maxLines: null, // Allows multiple lines of text
                          keyboardType: TextInputType
                              .number, // Set the keyboard type to number
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Allow only digits
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Remarks:',
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'New Location:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 5, 25, 15),
                      child: DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                          });
                        },
                        isExpanded: true,
                        items: DropdownMenuItemBuilder.build(items),
                      ),
                    ),
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
                          if ((_imageFile1 != null) &&
                              (selectedValue != null) &&
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
                              Icons.transfer_within_a_station,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Transfer',
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

// truck_code, truck_title, truck_location,   truck_status, truck_brand, truck_category, vehicle_type, chassis_series, chassis_type, chassis_length, chassis_num, year_model, front_panel, cabin_type,  cabin_height, chrome_type, fi_system, transmission, transmission_speed, cabchassis_differential, registered_name, plate_num,
