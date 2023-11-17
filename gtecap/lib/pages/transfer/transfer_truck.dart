import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gtecap/main.dart';
import 'package:gtecap/pages/transfer/t_qr_scan.dart';
import 'package:gtecap/pages/transfer/view_transferred.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransferTruck extends StatefulWidget {
  const TransferTruck({Key? key}) : super(key: key);

  @override
  State<TransferTruck> createState() => _TransferTruckState();
}

class _TransferTruckState extends State<TransferTruck> {
  TextEditingController searchController = TextEditingController();
  String? branch, current_position, status;
  List<DataRow> filteredRows = [];
  List<Map<String, dynamic>> data = [];

  void _setQrCode(String? Code, String? state, String? transfer_id) async {
    // view the qrcode details
    // print('QR Code Data: ${Code!}');

    try {
      // Obtain shared preferences.

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.https(
          'clambagojbmgeos12435aqwdvcxwetv7543.com', 'Api/public/check/qrcode');
      var response = await http.post(url, body: {
        'qrcode_value': Code,
        'transfer_id': transfer_id,
      });
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Successful POST request
        final responseData = json.decode(response.body);

        // print(respon seData['data']['user_id']);
        // print(responseData['data']['user_fname']);
        // print(responseData['message']);
        if ((responseData['status'] == 'success') ||
            (responseData['details'] != "")) {
          await prefs.setString('transfer_id', transfer_id!);

          await prefs.setString('drivername',
              responseData['driver_details']['driver_name'].toString());
          await prefs.setString('contactNumber',
              responseData['driver_details']['contact_number'].toString());
          await prefs.setString(
              'title', responseData['details']['truck_title'].toString());
          await prefs.setString('state', state.toString());
          await prefs.setString(
              'truckcode', responseData['details']['truck_code'].toString());

          await prefs.setString('display_image',
              responseData['details']['display_img'].toString());

          await prefs.setString(
              'platenum', responseData['details']['plate_num'].toString());
          await prefs.setString(
              'brand', responseData['details']['truck_brand'].toString());
          await prefs.setString(
              'category', responseData['details']['truck_category'].toString());
          await prefs.setString(
              'type', responseData['details']['vehicle_type'].toString());
          await prefs.setString('Chassis_Series',
              responseData['details']['chassis_series'].toString());
          await prefs.setString(
              'year', responseData['details']['year_model'].toString());
          await prefs.setString(
              'frontpanel', responseData['details']['front_panel'].toString());
          await prefs.setString(
              'chrometype', responseData['details']['chrome_type'].toString());
          await prefs.setString('transmission',
              responseData['details']['transmission'].toString());
          await prefs.setString('registered',
              responseData['details']['registered_name'].toString());
          await prefs.setString(
              'location', responseData['details']['truck_location'].toString());
          // print(truck);
          // in this part we will going to insert the values on data on our session code.

          // change scene to dashboard
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewTransferred()),
          );
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            headerAnimationLoop: false,
            title: 'Truck Unit not found!',
            desc: 'No details found from the truck code: ${Code}',
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red,
          ).show();
        }
      } else {
        // Handle errors here
        print('Post request failed with status code: ${response.statusCode}');
        // You can add more error handling here as needed.
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branch = prefs.getString('brn_code');
    current_position = prefs.getString('user_position');

    final Uri url = Uri.parse(
      'https://clambagojbmgeos12435aqwdvcxwetv7543.com/Api/public/truck-transfered?branch=$branch&user_position=$current_position',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Update the data variable with the data from the API response
          data = List<Map<String, dynamic>>.from(responseData['data']);
          print(data);
        } else {
          throw Exception(
              'API request failed with status: ${responseData['status']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterData(String query) {
    filteredRows.clear();
    for (var item in data) {
      if ((item['truck_code']!.toLowerCase().contains(query.toLowerCase())) ||
          (item['transfer_status']!
              .toLowerCase()
              .contains(query.toLowerCase()))) {
        if (item['transfer_status'] == "Active") {
          status = "In transit";
          item['transfer_status'] = status;
        } else {
          status = item['transfer_status'];
        }
        filteredRows.add(
          DataRow(
            cells: [
              DataCell(Text(
                item['truck_code']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              )),
              DataCell(Text(
                item['date_sent']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              )),
              DataCell(Text(
                item['date_recieved']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              )),
              DataCell(
                Text(
                  item['from_brncode']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              DataCell(Text(
                item['to_brncode']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              )),
              DataCell(Text(
                status!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              )),
              DataCell(
                SizedBox(
                  width: 60,
                  height: 25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      _setQrCode(item['truck_code']!, item['transfer_status']!,
                          item['transfer_id']!);
                    },
                    child: Text(
                      'View',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    setState(() {}); // Update the UI
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
    fetchData(); // Call the fetchData function when the widget initializes
    filterData("");
    _userDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: Text('Transferred'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 10, 20, 10), // Adjust left and right padding
            child: ElevatedButton(
              onPressed: () {
                // Navigate to another screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TQRScanner(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(
                    255, 33, 153, 28), // Change the background color here
              ),
              child: Text(
                '+ Transfer a truck',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterData(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter a name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0.0),
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 28.0,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Truck Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date (transferred)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date (Received)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'From Branch',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'To Branch',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                  rows: filteredRows,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
