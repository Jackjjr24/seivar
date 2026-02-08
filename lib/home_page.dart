import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'just_for_you.dart';
import 'main.dart';
import 'ManageSubscriptionsPage.dart';
import 'SettingsPage.dart';
import 'booking.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.28;

    return Scaffold(
      appBar: AppBar(
        title: Text("SEIVAR"),
        backgroundColor: Colors.lightBlue.shade100,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.person), onPressed: () {}),
        ],
      ),
      drawer: _buildSidebar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequestedServicesSection(context),

            _buildSectionTitle("Our Services"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildServiceBox(context, "Dishwashing", "assets/dishwashing.jpg", boxWidth),
                _buildServiceBox(context, "Home Cleaning", "assets/home-cleaning-1.jpg", boxWidth),
                _buildServiceBox(context, "Household", "assets/household.jpg", boxWidth),
              ],
            ),
            SizedBox(height: 20),

            _buildSectionTitle("Categories"),
            SizedBox(height: 10),
            _buildHorizontalCategories(),

            SizedBox(height: 20),
            _buildSectionTitle("Previously Used Services"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildServiceBox(context, "Dishwashing", "assets/dishwashing.jpg", boxWidth),
                _buildServiceBox(context, "Home Cleaning", "assets/home-cleaning-1.jpg", boxWidth),
                _buildServiceBox(context, "Household", "assets/household.jpg", boxWidth),
              ],
            ),

            SizedBox(height: 30),
            _buildPremiumBanner(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue.shade100,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
        onTap: (index) {
          if (index == 0) {
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageSubscriptionsPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }
        },
      ),
    );
  }

  // 🔹 Requested Services Section with Delete Confirmation
  Widget _buildRequestedServicesSection(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("bookings")
          .where("userId", isEqualTo: user.uid)
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox();
        }

        var bookings = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Requested Services"),
            ListView.builder(
              itemCount: bookings.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var bookingDoc = bookings[index];
                var data = bookingDoc.data() as Map<String, dynamic>;

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: data["serviceImage"] != null
                        ? Image.asset(data["serviceImage"], width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.miscellaneous_services, size: 40, color: Colors.indigo),
                    title: Text(
                      data["serviceName"] ?? "Unknown Service",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data["date"] != null) Text("Date: ${data["date"]}"),
                        if (data["time"] != null) Text("Time: ${data["time"]}"),
                        if (data["location"] != null) Text("Location: ${data["location"]}"),
                        Text("Status: ${data["status"] ?? "pending"}",
                            style: TextStyle(
                              color: (data["status"] == "pending") ? Colors.orange : Colors.green,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool confirm = await _showDeleteConfirmationDialog(context);
                        if (confirm) {
                          await FirebaseFirestore.instance
                              .collection("bookings")
                              .doc(bookingDoc.id)
                              .delete();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // 🔹 Confirmation dialog
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to remove this service request?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ) ??
        false;
  }

  // 🔹 Horizontal categories
  Widget _buildHorizontalCategories() {
    List<Map<String, dynamic>> categories = [
      {"name": "Household", "icon": Icons.home},
      {"name": "Caretaking", "icon": Icons.accessible},
      {"name": "Electrician", "icon": Icons.electrical_services},
      {"name": "Plumbing", "icon": Icons.plumbing},
      {"name": "Cleaning", "icon": Icons.cleaning_services},
    ];

    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: EdgeInsets.only(right: 10),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categories[index]["icon"], size: 30, color: Colors.indigo),
                    SizedBox(height: 8),
                    Text(
                      categories[index]["name"],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 🔹 Sidebar Drawer
  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue.shade100),
            child: Center(
              child: Text("SEIVAR", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.indigo),
            title: Text("Home"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.book_online, color: Colors.indigo),
            title: Text("Subscription"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageSubscriptionsPage()),
              );
            },
          ),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
    );
  }

  Widget _buildServiceBox(BuildContext context, String name, String imagePath, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceBookingPage(
              serviceName: name,
              serviceImage: imagePath,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: width,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 5),
          Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFD7D2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hold up! Get your personalized plan here..",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            softWrap: true,
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JustForYouPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Unlock with premium", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Icon(Icons.star, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
