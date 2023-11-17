import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gtecap/pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // variables
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

  void showNoIntenetDialog(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'Oops!',
      desc: 'No internet connection',
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  // this part of the code will check if there is already credential
  void _userDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_id')) {
      // change scene to dashboard
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  Future<void> _login() async {
    try {
      // Obtain shared preferences.

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.https(
          'clambagojbmgeos12435aqwdvcxwetv7543.com', 'Api/public/verify');
      var response = await http.post(url, body: {
        'email': emailController.text,
        'password': passController.text
      });
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Successful POST request
        final responseData = json.decode(response.body);

        // print(respon seData['data']['user_id']);
        // print(responseData['data']['user_fname']);
        // print(responseData['message']);
        if (responseData['status'] == 'success') {
          // print(responseData['message']);
          if (responseData['data']['user_position'] != 'Administrator' &&
              responseData['data']['user_position'] != 'Warehouse Checker') {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("The account can't access this application."),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // print(responseData['data']['brn_code']);
            await prefs.setString(
                'firstname', responseData['data']['user_fname'].toString());
            await prefs.setString(
                'middlename', responseData['data']['user_mname'].toString());
            await prefs.setString(
                'lastname', responseData['data']['user_lname'].toString());

            await prefs.setString('user_profileImg',
                responseData['data']['user_profileImg'].toString());

            await prefs.setString(
                'user_id', responseData['data']['user_id'].toString());

            await prefs.setString('user_position',
                responseData['data']['user_position'].toString());

            await prefs.setString(
                'user_email', responseData['data']['user_email'].toString());

            await prefs.setString('user_contact',
                responseData['data']['user_contact'].toString());

            await prefs.setString(
                'user_status', responseData['data']['user_status'].toString());

            await prefs.setString('user_address1',
                responseData['data']['user_address1'].toString());

            await prefs.setString(
                'user_brgy', responseData['data']['user_brgy'].toString());

            await prefs.setString('user_municipality',
                responseData['data']['user_municipality'].toString());

            await prefs.setString('user_province',
                responseData['data']['user_province'].toString());

            await prefs.setString(
                'brn_code', responseData['data']['brn_code'].toString());

            // in this part we will going to insert the values on data on our session code.

            // change scene to dashboard
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          }
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle errors here
        // print('Post request failed with status code: ${response.statusCode}');
        // You can add more error handling here as needed.
      }
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw (e);
    }
  }

  @override
  void initState() {
    super.initState();
    _userDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Form(
            key: _formField,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Image.asset(
                  'assets/images/textlogo.png',
                  height: 100,
                  width: 300,
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter email.";
                    }
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!emailValid) {
                      return "Enter valid email.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: Icon(passToggle
                            ? Icons.visibility
                            : Icons.visibility_off)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your password";
                    } else if (passController.text.length < 6) {
                      return "Password must be 6 to 10 of length.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 60),
                AnimatedButton(
                  text: "LOG IN",
                  buttonTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  pressEvent: () async {
                    if (_formField.currentState!.validate()) {
                      final connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        showNoIntenetDialog(context);
                      } else {
                        _login();
                      }
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Viewdetails()),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
