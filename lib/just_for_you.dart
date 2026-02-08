import 'package:flutter/material.dart';
import 'payment.dart'; // Import the Payment Page

class JustForYouPage extends StatelessWidget {
  final List<Map<String, dynamic>> services = [
    {
      "days": "10 Days",
      "originalPrice": "₹1000",
      "discountedPrice": "₹800",
      "availableUtilities": 10,
      "image": "assets/dishwashing.jpg",
    },
    {
      "days": "10 Days",
      "originalPrice": "₹1000",
      "discountedPrice": "₹800",
      "availableUtilities": 20,
      "image": "assets/home-cleaning-1.jpg",
    },
    {
      "days": "10 Days",
      "originalPrice": "₹1000",
      "discountedPrice": "₹800",
      "availableUtilities": 15,
      "image": "assets/household.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double totalCost = 3000;
    double discountedCost = 2700;
    double platformFee = 20;
    double travelFee = 220;
    double gstCost = 200;
    double totalAmount = discountedCost + platformFee + travelFee + gstCost;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SEIVAR", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo)),
            SizedBox(width: 10),
            Icon(Icons.person, color: Colors.indigo),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("JUST FOR YOU", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
            ),
            SizedBox(height: 15),
            ...services.asMap().entries.map((entry) {
              int index = entry.key + 1;
              Map<String, dynamic> service = entry.value;
              return _buildServiceCard(service, index);
            }).toList(),
            SizedBox(height: 15),
            _buildPriceSummary(totalCost, discountedCost, platformFee, travelFee, gstCost, totalAmount),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentPage()), // Navigate to Payment Page
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Avail", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_right_alt, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.indigo,
              child: Text("$index", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(service["image"], width: 60, height: 60, fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service["days"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(service["originalPrice"], style: TextStyle(fontSize: 14, color: Colors.red, decoration: TextDecoration.lineThrough)),
                      SizedBox(width: 10),
                      Text(service["discountedPrice"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ],
                  ),
                  Text("Available utilities: ${service["availableUtilities"]}", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(double total, double discounted, double platform, double travel, double gst, double amount) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRow("Total Cost of the Services listed", total),
          _buildPriceRow("Discounted Cost of the Services listed", discounted),
          _buildPriceRow("Platform fee", platform),
          _buildPriceRow("Travel distance fee", travel),
          _buildPriceRow("Service GST cost", gst),
          _buildPriceRow("Amount to be paid", amount, isBold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("₹${value.toStringAsFixed(0)}", style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
