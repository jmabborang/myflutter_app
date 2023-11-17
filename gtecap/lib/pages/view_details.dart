import 'package:flutter/material.dart';
import 'package:gtecap/main.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Viewdetails extends StatefulWidget {
  const Viewdetails({super.key});

  @override
  State<Viewdetails> createState() => _ViewdetailsState();
}

class _ViewdetailsState extends State<Viewdetails> {
  String? user_type,
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
      location;

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
      user_type = prefs.getString('user_position').toString();

      title = prefs.getString('title').toString();
      truck_code = prefs.getString('truckcode').toString();
      display = prefs.getString('display_image').toString();
      platenum = prefs.getString('platenum').toString();
      brand = prefs.getString('brand').toString();
      category = prefs.getString('category').toString();
      type = prefs.getString('type').toString();
      chassis_series = prefs.getString('Chassis_Series').toString();
      year = prefs.getString('year').toString();
      frontpanel = prefs.getString('frontpanel').toString();
      chrometype = prefs.getString('chrometype').toString();
      transmission = prefs.getString('transmission').toString();
      registered = prefs.getString('registered').toString();
      location = prefs.getString('location').toString();
      if (category == 'LCV') {
        category = "Light Commercial Vehicle";
      } else if (category == 'MCV') {
        category = "Medium Commercial Vehicle";
      } else if (category == 'HCV') {
        category = "Heavy Commercial Vehicle";
      }
      display =
          'https://clambagojbmgeos12435aqwdvcxwetv7543.com/${display!.substring(3)}';
    });
  }

  @override
  void initState() {
    super.initState();
    _userDetails();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8), // Adjust the radius as needed
                    child: Image.network(
                      display!,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
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
                padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Description')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Truck Code')),
                          DataCell(Text(truck_code!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Plate Number')),
                          DataCell(Text(platenum!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Brand')),
                          DataCell(Text(brand!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Vehicle Category:')),
                          DataCell(Text(category!))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Type')),
                          DataCell(Text(type!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Chassis Series')),
                          DataCell(Text(chassis_series!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Year Model')),
                          DataCell(Text(year!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Front Panel')),
                          DataCell(Text(frontpanel!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Chrome Type')),
                          DataCell(Text(chrometype!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Transmission')),
                          DataCell(Text(transmission!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Registered Name')),
                          DataCell(Text(registered!)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Location')),
                          DataCell(Text(location!)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
              // if (user_type != 'Administdrator')
              //   Container(
              //     child: Padding(
              //       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              //       child: ElevatedButton(r
              //         onPressed: () {},
              //         child: Text('Would you like to transfer this truck?'),
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
