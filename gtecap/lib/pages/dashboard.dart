import 'package:flutter/material.dart';
import 'package:gtecap/main.dart';
import 'package:gtecap/pages/my_profile.dart';
import 'package:gtecap/pages/qr_scan.dart';
import 'package:gtecap/pages/received/r_qr_scan.dart';
import 'package:gtecap/pages/transfer/transfer_truck.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  var height, width;
  List imageSrc = [
    // "assets/dashboard_logos/truck.png",
    "assets/dashboard_logos/delivery-truck.png",
    "assets/dashboard_logos/exchange.png",
    "assets/dashboard_logos/qr-code-scan.png",
    "assets/dashboard_logos/profile.png",
  ];

  List titles = [
    // "Trucks",
    "Received",
    "Transferred",
    "View Truck Details",
    "My Profile",
  ];
  final List<Widget> _screens = [
    // Parts(),
    // RQRScanner(),
    RQRScanner(),
    TransferTruck(),
    // Viewdetails(),
    QRScanner(),
    Profile(),
    // Add more screens as needed
  ];
  String? firstname, userImage, formattedDate;

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

  Future<void> setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
      userImage = prefs.getString('user_profileImg');

      firstname = prefs.getString('firstname');

      if (userImage != null && userImage!.length > 3) {
        userImage =
            'https://clambagojbmgeos12435aqwdvcxwetv7543.com/${userImage!.substring(3)}';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
    _userDetails();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    double mainSize = 30;
    return Scaffold(
      drawer: Navbar(),
      body: Container(
        color: Colors.lightGreen,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                ),
                height: height * 0.27,
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 50,
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(onTap: () {}, child: Container()),
                          ClipOval(
                            child: userImage != null
                                ? Image.network(
                                    userImage!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  )
                                : CircularProgressIndicator(), // Add a loading indicator for user_image
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${firstname}!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Today: ${formattedDate}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(mainSize),
                    topRight: Radius.circular(mainSize),
                  ),
                ),
                height: height * .90,
                width: width,
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 6,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: imageSrc.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => _screens[index]),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                  ),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  imageSrc[index],
                                  width: 75,
                                ),
                                Text(titles[index]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
