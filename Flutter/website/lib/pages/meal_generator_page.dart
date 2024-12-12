import 'package:flutter/material.dart';
import 'package:website/components/custom_footer.dart';
import 'package:website/pages/daily_meal_page_2.dart';
import 'package:website/pages/macro_calculator_page.dart';

void main() {
  runApp(MaterialApp(home: MealGenerator()));
}

class MealGenerator extends StatefulWidget {
  @override
  _MealGeneratorState createState() => _MealGeneratorState();
}

class _MealGeneratorState extends State<MealGenerator> {
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String dietaryPreference = 'Vegetarian';
  int numberOfMeals = 3;
  int numberOfDays = 5;

  bool get _isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.125,
            decoration: const BoxDecoration(
              color: Color(0xFF0C1F27),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.125,
            child: Column(children: [
              // Navigation Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      height: 50,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Home",
                              style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MacroCalculatorPage()),
                              );
                            },
                            child: const Text(
                              "Calculate Macros",
                              style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealGenerator()),
                              );
                            },
                            child: const Text(
                              "Meal Generator",
                              style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
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
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Shop Now',
                              style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
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
      // Macro Calculator Section
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: const Color(0xC90C1E26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                'Macro Calculator',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Macros are confusing. However, macros are a crucial part of your nutrition.\nThis tool will help you set up the roadmap for your dietary needs.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0x940C1E26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('Enter Daily Macros',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                _buildTextField(
                                    _caloriesController, 'Calories'),
                                _buildTextField(_carbsController, 'Carbs (g)'),
                                _buildTextField(
                                    _proteinController, 'Protein (g)'),
                                _buildTextField(_fatsController, 'Fats (g)'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Enter Daily Macros',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Expanded(
                                    child: _buildDropdown(
                                        'Dietary Preferences',
                                        ['None', 'Vegetarian', 'Vegan'],
                                        dietaryPreference, (String? newValue) {
                                  setState(() {
                                    dietaryPreference = newValue!;
                                  });
                                })),
                                Expanded(
                                    child: _buildDropdown(
                                        'Number of Meals',
                                        [1, 2, 3, 4, 5],
                                        numberOfMeals, (int? newValue) {
                                  setState(() {
                                    numberOfMeals = newValue!;
                                  });
                                })),
                                Expanded(
                                    child: _buildDropdown(
                                        'Number of Days',
                                        [1, 2, 3, 4, 5, 6, 7],
                                        numberOfDays, (int? newValue) {
                                  setState(() {
                                    numberOfDays = newValue!;
                                  });
                                })),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _isFormValid
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DailyMealPlanPage(
                                          selectedMacros: {
                                            'Protein': double.parse(
                                                _proteinController.text),
                                            'Carbohydrates': double.parse(
                                                _carbsController.text),
                                            'Fats': double.parse(
                                                _fatsController.text),
                                            'Calories': double.parse(
                                                _caloriesController.text),
                                          },
                                          dietaryPreference: dietaryPreference,
                                          numberOfMeals: numberOfMeals,
                                          numberOfDays: numberOfDays,
                                          calculateMacros: false,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MacroCalculatorPage()),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 280, // Set the desired width here
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0C1F27),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Don\'t know my Macros',
                                            style: TextStyle(
                                              color: Colors.white, // White text
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 280, // Set the desired width here
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      decoration: BoxDecoration(
                                        color: _isFormValid
                                            ? const Color(0xFF0C1F27)
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Generate My Meals',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ])));
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      padding: EdgeInsets.all(25),
      width: 180,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white), // Set text color to white
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.white), // Set label text color to white
          filled: true,
          fillColor: Color(0xFF112025),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Colors.grey), // Border color when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: Colors.green, width: 2), // Border color when focused
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {}); // Call setState to update the button color
        },
      ),
    );
  }

  Widget _buildDropdown<T>(String label, List<T> options, T selectedValue,
      ValueChanged<T?> onChanged,
      {double width = 150}) {
    return Container(
      padding: EdgeInsets.all(25),
      width: width,
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Colors.white), // Set label text color to white
          filled: true,
          fillColor: Color(0xFF112025),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.grey), // Border color when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Colors.green, width: 2), // Border color when focused
          ),
        ),
        dropdownColor: Colors.green, // Background color of the dropdown items
        value: selectedValue,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(value.toString(),
                style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        style: const TextStyle(
            color: Colors.black), // Set text color of dropdown items to white
      ),
    );
  }
}
