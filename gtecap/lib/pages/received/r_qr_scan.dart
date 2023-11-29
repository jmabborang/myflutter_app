import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gtecap/pages/received/alter_received.dart';
import 'package:gtecap/pages/received/r_view_details.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RQRScanner extends StatelessWidget {
  const RQRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: const Text('Received'),
      ),
      body: const Center(
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
  String? user_brncode, position, from_brncode, to_brncode;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // ignore: non_constant_identifier_names
  setQrCode(String? Code) async {
    // view the qrcode details
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('truck_code', Code!);
    user_brncode = prefs.getString('brn_code');
    position = prefs.getString('user_position');

    try {
      var url = Uri.https('clambagojbmgeos12435aqwdvcxwetv7543.com',
          'Api/public/transfer/qrcodes');
      var response = await http.post(url, body: {
        'qrcode': Code,
        'brncode': user_brncode,
        'position': position
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Successful POST request
        // final responseAPI = response.body;
        final responseData = json.decode(response.body);

        // print(responseAPI[]);
        if (responseData['status'] == 'success') {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RViewDetails()),
          );
        } else if (responseData['status'] == 'unable to receive') {
          // await prefs.setString('truck_code',
          //     responseData['truck_details']['truck_code'].toString());
          to_brncode = responseData['truck_details']['to_brncode'];
          from_brncode = responseData['truck_details']['from_brncode'];
          // received_brncode= responseData['truck_details']['to_brncode'];
          print('Branch Code:${to_brncode}');

          await prefs.setString('brnCode_dest', to_brncode.toString());
          await prefs.setString('transfer_brncode', from_brncode.toString());
          await prefs.setString('received_brncode', user_brncode.toString());

          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            headerAnimationLoop: false,
            animType: AnimType.bottomSlide,
            title: 'Truck was not allocated to the branch.',
            desc: 'Do you still want to receive it?',
            buttonsTextStyle: const TextStyle(color: Colors.black),
            showCloseIcon: true,
            btnCancelOnPress: () {
              // back to dashboard
            },
            btnOkOnPress: () {
              // proceed to received the truck and the remarks is required
              // truck transfer was being altered to be received by the other branch
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlterRViewDetails()),
              );
            },
          ).show();
        } else {
          // ignore: use_build_context_synchronously
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            headerAnimationLoop: false,
            title: 'No active transfer!',
            desc: responseData['message'],
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

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                          child: Text(
                            'Truck Code: ${result!.code}',
                            style: TextStyle(
                              color: Colors.black26,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: ElevatedButton(
                            onPressed: () {
                              setQrCode(result!.code);
                            },
                            child: Text(
                              'Received',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        //   child: SizedBox(
                        //     width: 60, // Set the desired width

                        //     height: 25, // Set the desired height
                        //     child: AnimatedButton(
                        //       text: 'View Details',
                        //       color: Color.fromARGB(255, 241, 205, 40),
                        //       pressEvent: () {
                        //
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                else
                  Container(), // Or another widget if you want to render something else when result is null
              ],
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
