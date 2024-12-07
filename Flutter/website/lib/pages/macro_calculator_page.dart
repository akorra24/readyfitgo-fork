import 'package:flutter/material.dart';
import 'package:website/pages/daily_meal_page_2.dart';

void main() {
  runApp(MaterialApp(home: MacroCalculatorPage()));
}

class MacroCalculatorPage extends StatefulWidget {
  @override
  _MacroCalculatorPageState createState() => _MacroCalculatorPageState();
}

class _MacroCalculatorPageState extends State<MacroCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _macrosCalculated = false;
  String? _macroError;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _proteinPercentageController =
      TextEditingController(text: '30');
  final TextEditingController _carbsPercentageController =
      TextEditingController(text: '40');
  final TextEditingController _fatPercentageController =
      TextEditingController(text: '30');

  String _sex = 'Male';
  String _activityLevel =
      'Lightly active (light exercise less than 3 days per week)';
  String _fitnessGoal = 'Lose Weight';
  String _dietaryPreference = 'None';
  int _numberOfMeals = 3;
  int _numberOfDays = 7;

  double _protein = 0.0;
  double _carbs = 0.0;
  double _fats = 0.0;
  double _calories = 0.0;

  void _validateInputs() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    // Validate that macro percentages sum to 100
    double proteinPercentage =
        double.tryParse(_proteinPercentageController.text) ?? 0;
    double carbsPercentage =
        double.tryParse(_carbsPercentageController.text) ?? 0;
    double fatPercentage = double.tryParse(_fatPercentageController.text) ?? 0;

    double totalPercentage =
        proteinPercentage + carbsPercentage + fatPercentage;

    if (totalPercentage != 100) {
      isValid = false;
      _macroError = 'Macro percentages must sum to 100%';
    } else {
      _macroError = null;
    }

    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  void _calculateMacros() {
    if (!_isButtonEnabled) return;

    if (_ageController.text.isEmpty ||
        _sex.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _activityLevel.isEmpty ||
        _fitnessGoal.isEmpty) {
      // Handle the error case where essential parameters are missing
      return;
    }

    double weight = double.parse(_weightController.text);
    double age = double.parse(_ageController.text);
    double height = double.parse(_heightController.text);

    double multiplier;
    switch (_activityLevel) {
      case 'Lightly active (light exercise less than 3 days per week)':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 11; // middle of the range 10-12
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 13; // middle of the range 12-14
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 16; // middle of the range 16-18
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 12; // slightly less than maintenance
        } else {
          multiplier = 13; // default to maintenance if goal is not specified
        }
        break;
      case 'Moderately active (moderate exercise 3-5 days per week)':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 13; // middle of the range 12-14
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 15; // middle of the range 14-16
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 18; // middle of the range 18-20
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 14; // slightly less than maintenance
        } else {
          multiplier = 15; // default to maintenance if goal is not specified
        }
        break;
      case 'Very active (intense exercise 6-7 days per week)':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 15; // middle of the range 14-16
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 17; // middle of the range 16-18
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 20; // middle of the range 20-22
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 16; // slightly less than maintenance
        } else {
          multiplier = 17; // default to maintenance if goal is not specified
        }
        break;
      default:
        multiplier =
            13; // default to maintenance if activity level is not specified
    }

    double dailyCaloricNeeds = weight * multiplier;

    double proteinPercentage = double.parse(_proteinPercentageController.text);
    double carbsPercentage = double.parse(_carbsPercentageController.text);
    double fatPercentage = double.parse(_fatPercentageController.text);

    setState(() {
      _calories = dailyCaloricNeeds;
      _protein = dailyCaloricNeeds * proteinPercentage / 100 / 4;
      _carbs = dailyCaloricNeeds * carbsPercentage / 100 / 4;
      _fats = dailyCaloricNeeds * fatPercentage / 100 / 9;
      _macrosCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: const BoxDecoration(
              color: Color(0xFF0C1F27),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(children: [
              // Navigation Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      height: 50,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Home",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MacroCalculatorPage()),
                            );
                          },
                          child: const Text(
                            "Calculate Macros",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Meal Generator",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // Button press action here
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white, // Text color
                            backgroundColor:
                                Colors.transparent, // Background color
                            side: const BorderSide(
                              color: Colors.white, // Border color
                              width: 1.0, // Border width
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0), // Button corner radius
                            ),
                          ),
                          child: const Text('Shop Now'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    ])));
  }

  Widget _buildMacroCard(String label, double value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${value.toStringAsFixed(0)} $unit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
