import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceBookingPage extends StatefulWidget {
  final String serviceName;
  final String serviceImage;

  const ServiceBookingPage({
    Key? key,
    required this.serviceName,
    required this.serviceImage,
  }) : super(key: key);

  @override
  _ServiceBookingPageState createState() => _ServiceBookingPageState();
}

class _ServiceBookingPageState extends State<ServiceBookingPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController instructionController = TextEditingController();

  Future<void> _bookService() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to book a service.")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("bookings").add({
        "userId": user.uid,
        "serviceName": widget.serviceName,
        "serviceImage": widget.serviceImage,
        "location": locationController.text,
        "date": dateController.text,
        "time": timeController.text,
        "instructions": instructionController.text,
        "status": "pending", // worker can later update
        "createdAt": FieldValue.serverTimestamp(),
      });

      _showBookingConfirmation();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book: $e")),
      );
    }
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Booking Confirmation"),
          content: Text("Your ${widget.serviceName} service has been booked successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${widget.serviceName} Service"),
        backgroundColor: Colors.lightBlue.shade100,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(widget.serviceImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Service Details
            Text(
              widget.serviceName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Professional ${widget.serviceName} service at your convenience",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            Divider(height: 30),

            // Form
            _buildForm(),

            SizedBox(height: 30),

            // Book Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _bookService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "BOOK NOW",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        // Location
        _buildInputCard(
          icon: Icons.location_on,
          iconColor: Colors.red,
          label: "Service Location",
          hint: "Enter your address",
          controller: locationController,
        ),
        SizedBox(height: 20),

        // Date + Time
        Row(
          children: [
            Expanded(
              child: _buildInputCard(
                icon: Icons.calendar_today,
                iconColor: Colors.blue,
                label: "Service Date",
                hint: "Select date",
                controller: dateController,
                onTap: _selectDate,
                readOnly: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildInputCard(
                icon: Icons.access_time,
                iconColor: Colors.green,
                label: "Service Time",
                hint: "Select time",
                controller: timeController,
                onTap: _selectTime,
                readOnly: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Instructions
        _buildInputCard(
          icon: Icons.note_add,
          iconColor: Colors.purple,
          label: "Special Instructions",
          hint: "Any specific requirements?",
          controller: instructionController,
        ),
      ],
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
