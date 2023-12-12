// Import necessary packages
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a StatefulWidget for the DetailsPlanScreen
class DetailsPlanScreen extends StatefulWidget {
  const DetailsPlanScreen({Key? key}) : super(key: key);

  @override
  _DetailsPlanScreenState createState() => _DetailsPlanScreenState();
}

// Define the state for the DetailsPlanScreen
class _DetailsPlanScreenState extends State<DetailsPlanScreen> {
  // Controller for the details text field
  TextEditingController detailsController = TextEditingController();

  // Variables for selected date, notification option, and dropdown item
  DateTime? selectedDate;
  Map<String, dynamic>? selectedNotificationOption;
  Map<String, dynamic>? selectedDropdownItem;

  // List of notification options with predefined days
  List<Map<String, dynamic>> notificationOptions = [
    {'days': 1, 'label': '1 Day Before'},
    {'days': 7, 'label': '7 Days Before'},
    {'days': 10, 'label': '10 Days Before'},
  ];

  // List of dropdown items with custom names and images
  List<Map<String, dynamic>> dropdownItems = [
    {
      'name': 'Select an OTT',
      'value': 0,
      'image': 'assets/images/all otts.png'
    },
    {'name': 'Amazon', 'value': 1, 'image': 'assets/images/AmazonPrime.png'},
    {
      'name': 'Disney+Hotstar',
      'value': 2,
      'image': 'assets/images/Disney-Hotstar.png'
    },
    {'name': 'Netflix', 'value': 3, 'image': 'assets/images/Netflix.png'},
    {'name': 'Zomato', 'value': 4, 'image': 'assets/images/Zomato.png'},
    // Add more items as needed
  ];

  // Build the UI for the DetailsPlanScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is the top app bar that usually contains the page title
      appBar: AppBar(
        title: const Text('Plan Details '),
        backgroundColor: const Color.fromARGB(221, 133, 198, 202),
      ),

      // Padding around the body content
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Column widget to organize child widgets vertically
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown menu with custom names and images
            DropdownButton<Map<String, dynamic>>(
              hint: const Text('Select an OTT'), // Set the OTT hint text
              value: selectedDropdownItem,
              onChanged: (value) {
                setState(() {
                  selectedDropdownItem = value;
                });
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Row(
                    children: [
                      // Image for the OTT logo
                      Image.asset(
                        item['image'],
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      // Text for the OTT name
                      Text(item['name']),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // TextField for entering plan details
            TextField(
              controller: detailsController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter Plan Details'),
            ),
            const SizedBox(height: 16),
            // Row widget for date selection
            Row(
              children: [
                Expanded(
                  // Display selected date or a default message
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                  ),
                ),
                // Button to show date picker
                TextButton(
                  onPressed: () async {
                    // Show date picker and update selectedDate
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dropdown for notification days
            DropdownButton<Map<String, dynamic>>(
              hint: const Text(
                  'Select Notification Days'), // Set the notification days hint text
              value: selectedNotificationOption,
              onChanged: (value) {
                setState(() {
                  selectedNotificationOption = value;
                });
              },
              items: notificationOptions.map((option) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: option,
                  child: Text(option['label']),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // ElevatedButton to save the subscription details
            ElevatedButton(
              onPressed: () async {
                // Validate input fields
                if (detailsController.text.isEmpty ||
                    selectedDate == null ||
                    selectedDropdownItem!['value'] == 0) {
                  // Validate that details, date, and ottName are not empty
                  // You can show a snackbar or an alert dialog for better user feedback
                  return;
                }

                // Create a new subscription data object
                final newData = {
                  'id': 'p${DateTime.now().millisecondsSinceEpoch}',
                  'details': int.parse(detailsController.text),
                  'date': selectedDate!.toIso8601String(),
                  'notificationDays': selectedNotificationOption!['days'],
                  'ottName': selectedDropdownItem!['name'], // Added ottName
                };

                // Save data to shared preferences
                final prefs = await SharedPreferences.getInstance();
                final List<String> existingData =
                    prefs.getStringList('subscriptionData') ?? [];
                existingData.add(json.encode(newData));
                prefs.setStringList('subscriptionData', existingData);

                // Pop the current screen and return the new data
                Navigator.pop(context, newData);
              },
              child: const Text('Save Subscription'),
            ),
          ],
        ),
      ),
    );
  }
}
