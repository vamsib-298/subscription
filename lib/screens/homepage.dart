// Import necessary packages and files
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscription/screens/details.dart';

// Define a StatefulWidget for the HomePage
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// Define the state for the HomePage
class _HomePageState extends State<HomePage> {
  // List to store subscription data
  List _items = [];

  // Initialize the state
  @override
  void initState() {
    super.initState();
    // Load subscription data from SharedPreferences when the widget is initialized
    readDataFromSharedPreferences();
  }

  // Read subscription data from SharedPreferences
  Future<void> readDataFromSharedPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    // Retrieve subscription data or initialize an empty list if no data is found
    final List<String> data = prefs.getStringList('subscriptionData') ?? [];

    // Update the state with the retrieved subscription data
    setState(() {
      _items = data.map((jsonString) => json.decode(jsonString)).toList();
    });
  }

  // Navigate to the DetailsPlanScreen and update the subscription data
  Future<void> navigateToDetailsPlan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetailsPlanScreen()),
    );

    // If result is not null, update the state with the new subscription data
    if (result != null) {
      setState(() {
        _items.add(result);
      });
    }
  }

  // Delete a subscription item and update SharedPreferences
  Future<void> deleteItem(int index) async {
    setState(() {
      _items.removeAt(index);
    });

    // Update SharedPreferences after deletion
    final prefs = await SharedPreferences.getInstance();
    final List<String> updatedData =
        _items.map((item) => json.encode(item)).toList();
    prefs.setStringList('subscriptionData', updatedData);
  }

  // Build the UI for the HomePage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is the top app bar that usually contains the page title
      appBar: AppBar(
        title: const Text('My Subscriptions'),
        backgroundColor: const Color.fromARGB(221, 133, 198, 202),
        // Actions are widgets that are placed on the right side of the AppBar
        actions: [
          IconButton(
            // Icon button for adding new subscriptions
            icon: const Icon(Icons.add),
            onPressed: navigateToDetailsPlan,
          ),
        ],
      ),
      // Background color for the body

      body: Padding(
        // Padding around the body content
        padding: const EdgeInsets.all(25),
        // Check if there are subscriptions available
        child: _items.isNotEmpty
            ? Expanded(
                // Use ListView.builder to display a list of subscription items
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    // Each subscription item is displayed as a Card
                    return Card(
                      margin: const EdgeInsets.all(3),
                      color: const Color.fromARGB(255, 187, 181, 125), // ListTile displays subscription details
                      child: ListTile(
                        // Display OTT name in bold and larger font
                        title: Text(
                          'OTT Name: ${_items[index]["ottName"]}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        // Display details, date, and notification days in white color
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plan Details: ${_items[index]["details"]}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 245, 245, 245)),
                            ),
                            Text(
                              'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(_items[index]["date"]))}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 234, 225, 225)),
                            ),
                            Text(
                              'Notification Days: ${_items[index]["notificationDays"]}',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 243, 243)),
                            ),
                          ],
                        ),
                        // IconButton for deleting a subscription item
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteItem(index),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(
                child: Text('No subscriptions available.'),
              ),
      ),
    );
  }
}
