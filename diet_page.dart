// disease_predictor_page.dart
import 'package:flutter/material.dart';

class DiseasePredictorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Predictor')),
      body: Center(child: Text('TFLite model will run here')),
    );
  }
}
