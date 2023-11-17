import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:gtecap/main.dart';
import 'package:gtecap/model/gallery_image.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewTransferred extends StatefulWidget {
  const ViewTransferred({Key? key}) : super(key: key);

  @override
  State<ViewTransferred> createState() => _ViewTransferredState();
}

class _ViewTransferredState extends State<ViewTransferred> {
  late String user_type,
      truck_code,
      title,
      platenum,
      display,
      brand,
      category,
      type,
      chassis_series,
      year,
      frontpanel,
      chrometype,
      transmission,
      registered,
      location,
      state,
      driver_name = "",
      contact_number = "",
      transfer_id;

  // this array will display load all the images for transfer
  List<String>? listOfUrlsTransfer; //upload mo n oks na pre uploaded na
  // dapat dito maloload yung galing ng API

  // this array will display load all the images for received
  // List<String> listOfUrls_received = ;

  Future<void> setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      transfer_id = prefs.getString('transfer_id') ?? '';
      driver_name = prefs.getString('drivername') ?? '';
      contact_number = prefs.getString('contactNumber') ?? '';
      state = prefs.getString('state') ?? '';
      title = prefs.getString('title') ?? '';
      truck_code = prefs.getString('truckcode') ?? '';
      display = prefs.getString('display_image') ?? '';
      platenum = prefs.getString('platenum') ?? '';
      brand = prefs.getString('brand') ?? '';
      category = prefs.getString('category') ?? '';
      type = prefs.getString('type') ?? '';
      chassis_series = prefs.getString('Chassis_Series') ?? '';
      year = prefs.getString('year') ?? '';
      frontpanel = prefs.getString('frontpanel') ?? '';
      chrometype = prefs.getString('chrometype') ?? '';
      transmission = prefs.getString('transmission') ?? '';
      registered = prefs.getString('registered') ?? '';
      location = prefs.getString('location') ?? '';

      if (category == 'LCV') {
        category = "Light Commercial Vehicle";
      } else if (category == 'MCV') {
        category = "Medium Commercial Vehicle";
      } else if (category == 'HCV') {
        category = "Heavy Commercial Vehicle";
      }

      display =
          'https://clambagojbmgeos12435aqwdvcxwetv7543.com/${display.substring(3)}';
    });
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
    setData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  display,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '    Details:',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Description')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Truck Code')),
                        DataCell(Text(truck_code)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Plate Number')),
                        DataCell(Text(platenum)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Brand')),
                        DataCell(Text(brand)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Vehicle Category:')),
                        DataCell(Text(category))
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Type')),
                        DataCell(Text(type)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Chassis Series')),
                        DataCell(Text(chassis_series)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Year Model')),
                        DataCell(Text(year)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Front Panel')),
                        DataCell(Text(frontpanel)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Chrome Type')),
                        DataCell(Text(chrometype)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Transmission')),
                        DataCell(Text(transmission)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Registered Name')),
                        DataCell(Text(registered)),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Location')),
                        DataCell(Text(location)),
                      ]),
                      if (driver_name != Null)
                        DataRow(cells: [
                          DataCell(Text('Driver')),
                          DataCell(Text(driver_name)),
                        ]),
                      if (contact_number != Null)
                        DataRow(cells: [
                          DataCell(Text('Contact')),
                          DataCell(Text(contact_number)),
                        ]),
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: size.height * 0.77,
                    child: FutureBuilder<GalleryImageModel>(
                      future: kFetchGalleryImage(transferId: transfer_id),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          // return ListView.builder(
                          //     itemCount: snapshot.data!.transferImage.length,
                          //     itemBuilder: (context, index) {
                          //       return Image.network(
                          //           snapshot.data!.transferImage[index]);
                          //     });
                          return Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 141, 248, 189),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Transfered',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GalleryImage(
                                    numOfShowImages:
                                        snapshot.data!.transferImage.length,
                                    imageUrls: snapshot.data!.transferImage,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Received',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GalleryImage(
                                    numOfShowImages:
                                        snapshot.data!.receivedImage.length,
                                    imageUrls: snapshot.data!.receivedImage,
                                    titleGallery: 'Received',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<GalleryImageModel> kFetchGalleryImage({required int transferId}) async {
//   final response = await http.get(Uri.parse(
//       'https://clambagojbmgeos12435aqwdvcxwetv7543.com/Api/public/get-images?transfer_id=$transferId'));
//   if (response.statusCode == 200) {
//     List<dynamic> jsonDataList = json.decode(response.body);
//     List<GalleryImageModel> imageData =
//         jsonDataList.map((json) => GalleryImageModel.fromJson(json)).toList();
//     print(imageData);
//     return imageData[0];
//   } else {
//     throw Exception('Failed to load product data');
//   }
// }

Future<GalleryImageModel> kFetchGalleryImage(
    {required String transferId}) async {
  final response = await http.get(
    Uri.parse(
        'https://clambagojbmgeos12435aqwdvcxwetv7543.com/Api/public/get-images?transfer_id=$transferId'),
  );
  if (response.statusCode == 200) {
    final images = GalleryImageModel.fromJson(jsonDecode(response.body));
    print(images.transferImage.length);

    for (int index = 0; index < images.transferImage.length; index++) {
      print(images.transferImage[index]);
    }
    return images;
  } else {
    throw Exception('Failed to load data');
  }
}
