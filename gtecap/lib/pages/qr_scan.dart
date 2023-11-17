import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gtecap/pages/view_details.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: Text("Scan QR Code"),
      ),
      body: Center(
        child: QRViewExample(),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final bool qr_validate;
  late final String? truck;

  _setQrCode(String? Code) async {
    // view the qrcode details
    // print('QR Code Data: ${Code!}');

    try {
      // Obtain shared preferences.

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.https(
          'clambagojbmgeos12435aqwdvcxwetv7543.com', 'Api/public/check/qrcode');
      var response = await http.post(url, body: {'qrcode_value': Code});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Successful POST request
        final responseData = json.decode(response.body);

        // print(respon seData['data']['user_id']);
        // print(responseData['data']['user_fname']);
        // print(responseData['message']);
        if (responseData['status'] == 'success') {
          // print(responseData['details']['truck_code']);
          await prefs.setString(
              'title', responseData['details']['truck_title'].toString());

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
            MaterialPageRoute(builder: (context) => Viewdetails()),
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

  // In order to get hot reload to work, we need to pause the camera if the platform
  // is Android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Truck Code: ${result!.code}',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _setQrCode(result!.code);
                                    },
                                    child: Text(
                                      'View Details',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  else
                    Container(), // Or another widget if you want to render something else when result is null
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example, we check how wide or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 1000 ||
            MediaQuery.of(context).size.height < 1000)
        ? 250.0
        : 500.0;
    // To ensure the Scanner view is properly sized after rotation,
    // we need to listen for Flutter SizeChanged notification and update the controller.
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 8,
        borderLength: 20,
        borderWidth: 20,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
