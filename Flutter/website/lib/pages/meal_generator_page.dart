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
      // appBar: CustomAppBar(
      //   title: '',
      // ),
      body: Stack(
        children: [
          // Background color
          Image.asset(
            'images/home_page.jpg', // Make sure the path to the image is correct
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.center,
                          child: Text.rich(
                            TextSpan(
                              text: 'Enter Your',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Daily Macros',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: <Widget>[
                            _buildTextField(_caloriesController, 'Calories'),
                            _buildTextField(_carbsController, 'Carbs (g)'),
                            _buildTextField(_proteinController, 'Protein (g)'),
                            _buildTextField(_fatsController, 'Fats (g)'),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                          child: SizedBox(
                            width: 280, // Set the desired width here
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                color:
                                    _isFormValid ? Colors.green : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MacroCalculatorPage()),
                            );
                          },
                          child: SizedBox(
                            width: 280, // Set the desired width here
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                                color: Colors.transparent, // Transparent fill
                                border: Border.all(
                                    color: Colors.green), // White border
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Don\'t know my Macros',
                                  style: TextStyle(
                                    color: Colors.green, // White text
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomFooter(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      width: 180,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white), // Set text color to white
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.white), // Set label text color to white
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
