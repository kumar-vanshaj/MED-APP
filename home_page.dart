import 'package:flutter/material.dart';
import 'package:medapp/disease_predictor_page.dart';
class HomePage extends StatelessWidget {
  Widget buildButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          width: 150,
          height: 130,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Color(0xFF008DDA)),
              SizedBox(height: 10),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Home"),
        backgroundColor: Color(0xFF008DDA),
      ),
      body: Center(
        child: GridView.count(
          padding: const EdgeInsets.all(24),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            buildButton("Disease Predictor", Icons.medical_services, () {
  Navigator.push(context, MaterialPageRoute(builder: (_) => DiseasePredictorPage()));
}),
            buildButton("Diet Chart", Icons.fastfood, () {}),
            buildButton("Medical History", Icons.history, () {}),
            buildButton("Contact Us", Icons.contact_mail, () {}),
          ],
        ),
      ),
    );
  }
}
