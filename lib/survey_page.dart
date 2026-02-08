import 'package:flutter/material.dart';
import 'home_page.dart';
class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  Map<String, String?> selectedOptions = {};
  final TextEditingController otherController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text("Survey Form"),
        backgroundColor: Colors.indigo,
        elevation: 5,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              _buildHeader("Help us understand you better!", cardWidth),
              _buildQuestionCard("What Type Of Work Do You Do (sector)?", ["IT", "Medical", "Construction", "Education", "Others"], cardWidth),
              _buildQuestionCard("What Time Do You Usually Start Your Day?", ["Morning", "Afternoon", "Evening", "Night"], cardWidth),
              _buildQuestionCard("When Does Your Work End?", ["Morning", "Afternoon", "Evening", "Night"], cardWidth),
              _buildQuestionCard("How Stressful Is Your Job?", ["Low", "Moderate", "High", "Very High"], cardWidth),
              _buildExpectationField(cardWidth),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to HomePage when Submit is clicked
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String text, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo), textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildQuestionCard(String question, List<String> options, double width) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      child: Container(
        width: width,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              children: options.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedOptions[question] == option,
                  onSelected: (selected) {
                    setState(() {
                      selectedOptions[question] = selected ? option : null;
                    });
                  },
                  selectedColor: Colors.indigo.shade200,
                  backgroundColor: Colors.grey.shade300,
                  labelStyle: TextStyle(
                    color: selectedOptions[question] == option ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
            if (options.contains("Others") && selectedOptions[question] == "Others")
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: otherController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Specify your answer",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpectationField(double width) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      child: Container(
        width: width,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What is Your Expectation From Our SEIVAR Force?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Type your expectations here...",
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
