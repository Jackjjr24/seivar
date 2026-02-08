import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVocalAssistantEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SEIVAR",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            _buildSectionTitle("Profile"),
            _buildSettingsTile(Icons.person, "Personal Data", () {}),
            _buildSettingsTile(Icons.settings, "Settings", () {}),
            _buildSettingsTile(Icons.book, "My Bookings", () {}),

            SizedBox(height: 10),

            _buildSectionTitle("Support"),
            _buildSettingsTile(Icons.help, "Help Center", () {}),
            _buildSettingsTile(Icons.delete_forever, "Request Account Deletion", () {}),
            _buildSettingsTile(Icons.person_add, "Add another account", () {}),

            SizedBox(height: 10),

            _buildVocalAssistantToggle(),
          ],
        ),
      ),

      // 🔥 Bottom Navigation Bar with Red Highlight for Settings
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue.shade100,
        selectedItemColor: Colors.red, // ✅ Settings Icon turns RED
        unselectedItemColor: Colors.black,
        currentIndex: 2, // ✅ Preselect Settings Tab
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Navigate back to Home
          } else if (index == 1) {
            // Navigate to Cart/Bookings Page
          } else if (index == 2) {
            // Stay on Settings Page
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: onTap,
      ),
    );
  }

  Widget _buildVocalAssistantToggle() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.record_voice_over, color: Colors.black),
        title: Text("Vocal Assistant"),
        trailing: Switch(
          value: isVocalAssistantEnabled,
          onChanged: (value) {
            setState(() {
              isVocalAssistantEnabled = value;
            });
          },
          activeColor: Colors.orange,
        ),
      ),
    );
  }
}
