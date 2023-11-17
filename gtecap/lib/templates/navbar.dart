import 'package:flutter/material.dart';
import 'package:gtecap/pages/dashboard.dart';
import 'package:gtecap/pages/qr_scan.dart';
import 'package:gtecap/pages/received/r_qr_scan.dart';
import 'package:gtecap/pages/transfer/transfer_truck.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  @override
  State<Navbar> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  String? branch, email, userImage, firstname, lastname, middlename, fullname;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userImage = prefs.getString('user_profileImg');
      branch = prefs.getString('brn_code');
      email = prefs.getString('user_email');
      firstname = prefs.getString('firstname');
      lastname = prefs.getString('lastname') ?? '';
      middlename = prefs.getString('middlename');
      fullname = "$firstname $middlename $lastname";
      if (userImage != null && userImage!.length > 3) {
        userImage =
            'https://clambagojbmgeos12435aqwdvcxwetv7543.com/${userImage!.substring(3)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("$firstname $middlename $lastname"),
            accountEmail: Text(email ?? 'Loading...'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: userImage != null
                    ? Image.network(
                        userImage!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(), // Add a loading indicator for user_image
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ),
          // ListTile(
          //   leading: Image.asset(
          //     'assets/images/truck_1297479.png',
          //     width: 20,
          //     height: 20,
          //   ),
          //   title: const Text("Trucks"),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => TransferTruck()),
          //     );
          //   },
          // ),
          ListTile(
            leading: Image.asset(
              'assets/images/icon-alternate-exchange.png',
              width: 20,
              height: 20,
            ),
            title: const Text("Transfer"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransferTruck()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/icon-check.png',
              width: 20,
              height: 20,
              color: Colors.black,
            ),
            title: const Text("Receive"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RQRScanner()),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/qr-icon.png',
              width: 20,
              height: 20,
              color: Colors.black,
            ),
            title: const Text("View Truck Details"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScanner()),
              );
            },
          ),
        ],
      ),
    );
  }
}
