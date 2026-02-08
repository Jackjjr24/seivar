import 'package:flutter/material.dart';

class ManageSubscriptionsPage extends StatefulWidget {
  @override
  _ManageSubscriptionsPageState createState() =>
      _ManageSubscriptionsPageState();
}

class _ManageSubscriptionsPageState extends State<ManageSubscriptionsPage> {
  double progressValue = 0.75; // 75% Progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildSidebar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage subscriptions :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              SizedBox(height: 10),
              _buildSubscriptionCard(),
              SizedBox(height: 20),
              Text(
                "Work in progress..",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              SizedBox(height: 10),
              _buildProgressSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.lightBlue.shade100,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SEIVAR",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          Icon(Icons.account_circle, size: 30, color: Colors.black),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue.shade100),
            child: Center(
              child: Text("SEIVAR",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.indigo),
            title: Text("Home"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.subscriptions, color: Colors.indigo),
            title: Text("Subscriptions"),
            onTap: () {},
          ),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/dishwashing.jpg", // Replace with actual image
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User’s SEIVAR pack",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Text("Validity : 10 days", style: TextStyle(fontSize: 14)),
                Text("Amount to be paid : ₹3140", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red, size: 30),
                onPressed: () {
                  // Decrease subscription count
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.green, size: 30),
                onPressed: () {
                  // Increase subscription count
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.yellow.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.yellow,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "${(progressValue * 100).toInt()}%",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.lightBlue.shade100,
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, size: 28, color: Colors.black54),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, size: 28, color: Colors.red),
              onPressed: () {
                // Already on this page, no action needed
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, size: 28, color: Colors.black54),
              onPressed: () {
                // Navigate to settings page
              },
            ),
          ],
        ),
      ),
    );
  }
}
