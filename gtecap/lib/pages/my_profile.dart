// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gtecap/main.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? branch,
      email,
      userImage,
      firstname,
      lastname,
      middlename,
      fullname,
      formattedDate,
      position,
      address1,
      brgy,
      municipal,
      province;

  Future<void> setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userImage = prefs.getString('user_profileImg');
      address1 = prefs.getString('user_address1');
      brgy = prefs.getString('user_brgy');
      municipal = prefs.getString('user_municipality');
      province = prefs.getString('user_province');
      position = prefs.getString('user_position');
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

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('firstname');
    await prefs.remove('middlename');
    await prefs.remove('lastname');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_contact');
    await prefs.remove('user_status');
    await prefs.remove('user_address1');
    await prefs.remove('user_brgy');
    await prefs.remove('user_municipality');
    await prefs.remove('user_province');
    await prefs.remove('brn_code');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  void initState() {
    super.initState();
    setData();
    _userDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            ClipOval(
              child: userImage != null
                  ? Image.network(
                      userImage!,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : CircularProgressIndicator(), // Add a loading indicator for user_image
            ),
            SizedBox(height: 20),
            Text(
              '$fullname',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$position',
              style: TextStyle(
                fontSize: 19,
                color: Colors.black87,
              ),
            ),
            Text(
              '$email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Address: $address1 $brgy $municipal,$province'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact: '),
            ),
            ListTile(
              leading: Icon(Icons.warehouse),
              title: Text('Branch Code: $branch'),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30,
                left: 15,
                right: 16,
              ),
              child: ElevatedButton(
                onPressed: () {
                  _logout();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 179, 179, 179)), // Change to your desired color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16)), // Adjust padding as needed
                  minimumSize: MaterialStateProperty.all<Size>(Size(
                      double.infinity,
                      50)), // Expand button to full width and set a custom height
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout, // You can use a different icon as needed
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(
                        width:
                            10), // Add some spacing between the icon and text
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors
                            .white, // Change text color to make it readable on the background color
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
