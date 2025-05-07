import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DiseasePredictorPage extends StatefulWidget {
  const DiseasePredictorPage({super.key});

  @override
  State<DiseasePredictorPage> createState() => _DiseasePredictorPageState();
}

class _DiseasePredictorPageState extends State<DiseasePredictorPage> {
  final TextEditingController _symptomController = TextEditingController();
  late Interpreter _interpreter;
  String _predictionResult = '';

  // Full list of symptoms (paste from your CSV)
  final List<String> _symptomsList = [
    "itching", "skin_rash", "nodal_skin_eruptions", "continuous_sneezing", "shivering", "chills", "joint_pain",
    "stomach_pain", "acidity", "ulcers_on_tongue", "muscle_wasting", "vomiting", "burning_micturition",
    "spotting_ urination", "fatigue", "weight_gain", "anxiety", "cold_hands_and_feets", "mood_swings",
    "weight_loss", "restlessness", "lethargy", "patches_in_throat", "irregular_sugar_level", "cough",
    "high_fever", "sunken_eyes", "breathlessness", "sweating", "dehydration", "indigestion", "headache",
    "yellowish_skin", "dark_urine", "nausea", "loss_of_appetite", "pain_behind_the_eyes", "back_pain",
    "constipation", "abdominal_pain", "diarrhoea", "mild_fever", "yellow_urine", "yellowing_of_eyes",
    "acute_liver_failure", "fluid_overload", "swelling_of_stomach", "swelled_lymph_nodes", "malaise",
    "blurred_and_distorted_vision", "phlegm", "throat_irritation", "redness_of_eyes", "sinus_pressure",
    "runny_nose", "congestion", "chest_pain", "weakness_in_limbs", "fast_heart_rate",
    "pain_during_bowel_movements", "pain_in_anal_region", "bloody_stool", "irritation_in_anus", "neck_pain",
    "dizziness", "cramps", "bruising", "obesity", "swollen_legs", "swollen_blood_vessels",
    "puffy_face_and_eyes", "enlarged_thyroid", "brittle_nails", "swollen_extremeties", "excessive_hunger",
    "extra_marital_contacts", "drying_and_tingling_lips", "slurred_speech", "knee_pain", "hip_joint_pain",
    "muscle_weakness", "stiff_neck", "swelling_joints", "movement_stiffness", "spinning_movements",
    "loss_of_balance", "unsteadiness", "weakness_of_one_body_side", "loss_of_smell", "bladder_discomfort",
    "foul_smell_of urine", "continuous_feel_of_urine", "passage_of_gases", "internal_itching",
    "toxic_look_(typhos)", "depression", "irritability", "muscle_pain", "altered_sensorium",
    "red_spots_over_body", "belly_pain", "abnormal_menstruation", "dischromic _patches",
    "watering_from_eyes", "increased_appetite", "polyuria", "family_history", "mucoid_sputum",
    "rusty_sputum", "lack_of_concentration", "visual_disturbances", "receiving_blood_transfusion",
    "receiving_unsterile_injections", "coma", "stomach_bleeding", "distention_of_abdomen",
    "history_of_alcohol_consumption", "blood_in_sputum", "prominent_veins_on_calf", "palpitations",
    "painful_walking", "pus_filled_pimples", "blackheads", "scurring", "skin_peeling",
    "silver_like_dusting", "small_dents_in_nails", "inflammatory_nails", "blister", "red_sore_around_nose",
    "yellow_crust_ooze"
  ];

  // Your disease class labels (finalized)
  final List<String> _diseaseClasses = [
    "Fungal infection", "Allergy", "GERD", "Chronic cholestasis", "Drug Reaction",
    "Peptic ulcer diseae", "AIDS", "Diabetes", "Gastroenteritis", "Bronchial Asthma",
    "Hypertension", "Migraine", "Cervical spondylosis", "Paralysis (brain hemorrhage)",
    "Jaundice", "Malaria", "Chicken pox", "Dengue", "Typhoid", "hepatitis A", "Hepatitis B",
    "Hepatitis C", "Hepatitis D", "Hepatitis E", "Alcoholic hepatitis", "Tuberculosis",
    "Common Cold", "Pneumonia", "Dimorphic hemmorhoids (piles)", "Heart attack",
    "Varicose veins", "Hypothyroidism", "Hyperthyroidism", "Hypoglycemia", "Osteoarthristis",
    "Arthritis", "(vertigo) Paroymsal Positional Vertigo", "Acne", "Urinary tract infection",
    "Psoriasis", "Impetigo"
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('disease_model.tflite');
  }

  void _predictDisease() {
    List<String> inputSymptoms = _symptomController.text
        .toLowerCase()
        .replaceAll(' ', '_')
        .split(',')
        .map((e) => e.trim())
        .toList();

    List<double> inputVector = List.filled(_symptomsList.length, 0.0);

    for (var symptom in inputSymptoms) {
      int index = _symptomsList.indexOf(symptom);
      if (index != -1) inputVector[index] = 1.0;
    }

    var input = [inputVector];
    var output = List.filled(_diseaseClasses.length, 0.0).reshape([1, _diseaseClasses.length]);

    _interpreter.run(input, output);

    int maxIndex = output[0].indexWhere((e) => e == output[0].reduce((a, b) => a > b ? a : b));
    String result = _diseaseClasses[maxIndex];

    setState(() {
      _predictionResult = "Predicted Disease: $result";
    });
  }

  @override
  void dispose() {
    _symptomController.dispose();
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disease Predictor"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Enter Symptoms (comma separated):"),
            const SizedBox(height: 10),
            TextField(
              controller: _symptomController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g. itching, skin_rash, vomiting',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictDisease,
              child: const Text("Predict Disease"),
            ),
            const SizedBox(height: 30),
            Text(
              _predictionResult,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
