import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gtecap/templates/navbar.dart';
import 'package:http/io_client.dart';

class Parts extends StatefulWidget {
  const Parts({super.key});

  @override
  State<Parts> createState() => _PartsState();
}

class _PartsState extends State<Parts> {
  TextEditingController searchController = TextEditingController();

  List<DataRow> filteredRows = [];
  List<Map<String, dynamic>> data = [];

  Future<void> fetchData() async {
    final ioClient = IOClient(
      HttpClient()..badCertificateCallback = (cert, host, port) => true,
    );

    try {
      final response = await ioClient.get(
        Uri.parse(
            'https://clambagojbmgeos12435aqwdvcxwetv7543.com/Api/public/partinventory'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Update the data variable with the data from the API response
          data = List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception(
              'API request failed with status: ${responseData['status']}');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      ioClient.close(); // Close the HTTP client to release resources
    }
  }

  void filterData(String query) {
    filteredRows.clear();
    for (var item in data) {
      if ((item['part_name']!.toLowerCase().contains(query.toLowerCase())) ||
          (item['part_category']!
              .toLowerCase()
              .contains(query.toLowerCase()))) {
        filteredRows.add(DataRow(
          cells: [
            DataCell(Text(
              item['part_name']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10, // Set your desired font size here
              ),
            )), // 'name' instead of 'Name'
            DataCell(Text(
              item['part_category']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10, // Set your desired font size here
              ),
            )), // 'age' instead of 'Category'
            DataCell(Text(
              item['part_qty']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                // Set your desired font size here
              ),
            )), // You can set the count here if needed
            DataCell(
              SizedBox(
                width: 60, // Set the desired width

                height: 25, // Set the desired height
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Set your desired background color here
                  ),
                  onPressed: () {
                    // Define the action to be performed when the button is pressed.
                    // For example, navigate to another screen.
                  },
                  child: Text(
                    'View',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 10,
                      // Text color
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      }
    }
    setState(() {}); // Update the UI
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    filterData(""); // Call the fetchData function when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0), // Set your desired padding here
            child: Align(
              alignment: Alignment.centerLeft, // Align text to the left
              child: Text(
                'Parts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25, // Set your desired font size here
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                // Call a function to filter the data
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
              child: DataTable(
                columnSpacing: 28.0,
                columns: [
                  DataColumn(
                      label: Text(
                    'Name', // Change 'Item' to 'Name'
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      // Text color
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Category', // Change 'Status' to 'Age'
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      // Text color
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Quantity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      // Text color
                    ),
                  )),
                  DataColumn(
                      label: Text(
                    'Action',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      // Text color
                    ),
                  )),
                ],
                rows: filteredRows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
