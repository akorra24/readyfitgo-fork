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

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

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
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  void _calculateMacros() {
    if (!_isButtonEnabled) return;

    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text);
    int age = int.parse(_ageController.text);

    // BMR Calculation
    double bmr;
    if (_sex == 'Male') {
      bmr = 4.536 * weight + 15.88 * height - 5 * age + 5;
    } else {
      bmr = 4.536 * weight + 15.88 * height - 5 * age - 161;
    }

    // Activity level multipliers
    Map<String, double> activityLevels = {
      'Sedentary': 1.2,
      'Lightly active (light exercise less than 3 days per week)': 1.375,
      'Moderately active (moderate exercise 3-5 days per week)': 1.55,
      'Very active (intense exercise 6-7 days per week)': 1.725,
      'Super active (very intense exercise or physical job)': 1.9,
    };

    // Goal adjustment in calories
    Map<String, double> goalAdjustments = {
      'Lose Weight': -500,
      'Maintain Weight': 0,
      'Gain Weight': 500,
    };

    // Daily caloric needs
    double dailyCalories =
        bmr * activityLevels[_activityLevel]! + goalAdjustments[_fitnessGoal]!;

    // Macro distribution percentages
    double carbsPercentage = 40.0;
    double proteinPercentage = 30.0;
    double fatPercentage = 30.0;

    setState(() {
      _calories = dailyCalories;
      _carbs = (dailyCalories * carbsPercentage) / 4 / 100;
      _protein = (dailyCalories * proteinPercentage) / 4 / 100;
      _fats = (dailyCalories * fatPercentage) / 9 / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/hii.jpeg', // Background image
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment:
                Alignment(2.0, -0.46), // Adjust alignment to slightly higher
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.7, // 80% of screen width
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Macro Calculator',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Macros are confusing. However, macros are a crucial part of your nutrition.\nThis tool will help you set up the roadmap for your dietary needs.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        onChanged: _validateInputs,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Body Composition',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: DropdownButtonFormField<String>(
                                      style: TextStyle(color: Colors.white),
                                      value: _sex,
                                      decoration: const InputDecoration(
                                        labelText: 'Sex',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      dropdownColor: Colors.grey[800],
                                      items: ['Male', 'Female']
                                          .map((label) => DropdownMenuItem(
                                                child: Text(label),
                                                value: label,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _sex = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: _ageController,
                                      decoration: const InputDecoration(
                                        labelText: 'Age',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter age';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      controller: _heightController,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Height (inches)',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter height';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: _weightController,
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Weight (lbs)',
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  185, 255, 255, 255)),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a valid number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // New Dropdowns
                            const Text(
                              'Preferences',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              style: TextStyle(color: Colors.white),
                              value: _dietaryPreference,
                              decoration: const InputDecoration(
                                labelText: 'Dietary Preference',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: ['None', 'Vegetarian', 'Vegan']
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _dietaryPreference = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              style: TextStyle(color: Colors.white),
                              value: _numberOfMeals,
                              decoration: const InputDecoration(
                                labelText: 'Number of Meals per Day',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: List.generate(6, (index) => index + 1)
                                  .map((label) => DropdownMenuItem(
                                        child: Text('$label'),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _numberOfMeals = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<int>(
                              style: TextStyle(color: Colors.white),
                              value: _numberOfDays,
                              decoration: const InputDecoration(
                                labelText: 'Number of Days',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: List.generate(7, (index) => index + 1)
                                  .map((label) => DropdownMenuItem(
                                        child: Text('$label'),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _numberOfDays = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              style: TextStyle(color: Colors.white),
                              value: _activityLevel,
                              decoration: const InputDecoration(
                                labelText: 'What is your activity level',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: [
                                'Lightly active (light exercise less than 3 days per week)',
                                'Moderately active (moderate exercise 3-5 days per week)',
                                'Very active (intense exercise 6-7 days per week)',
                              ]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _activityLevel = value!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              style: TextStyle(color: Colors.white),
                              value: _fitnessGoal,
                              decoration: const InputDecoration(
                                labelText: 'What are your fitness goals',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(185, 255, 255, 255)),
                                ),
                              ),
                              dropdownColor: Colors.grey[800],
                              items: [
                                'Lose Weight',
                                'Maintain Weight',
                                'Gain Weight',
                              ]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _fitnessGoal = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        // This will center the button horizontally
                        child: GestureDetector(
                          onTap: _isButtonEnabled
                              ? () {
                                  // Ensure that all inputs are valid
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DailyMealPlanPage(
                                          age:
                                              int.tryParse(_ageController.text),
                                          sex: _sex,
                                          height: double.tryParse(
                                              _heightController.text),
                                          weight: double.tryParse(
                                              _weightController.text),
                                          activityLevel: _activityLevel,
                                          fitnessGoal: _fitnessGoal,
                                          dietaryPreference: _dietaryPreference,
                                          numberOfMeals: _numberOfMeals,
                                          numberOfDays: _numberOfDays,
                                          calculateMacros:
                                              true, // Assuming this flag triggers macro calculation
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.2, // Adjust the width
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                color: _isButtonEnabled
                                    ? Colors.white
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Generate',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Display Macros
                      if (_isButtonEnabled) ...[
                        const Divider(
                            color: Color.fromARGB(130, 255, 255, 255)),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromARGB(185, 255, 255, 255)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Daily Macros',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildMacroCard('Calories', _calories, 'cal'),
                                  _buildMacroCard('Carbs', _carbs, 'g'),
                                  _buildMacroCard('Protein', _protein, 'g'),
                                  _buildMacroCard('Fats', _fats, 'g'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
