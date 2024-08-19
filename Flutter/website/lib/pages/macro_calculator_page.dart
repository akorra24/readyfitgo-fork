import 'package:flutter/material.dart';

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

  void _validateInputs() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/home_page.jpg', // Make sure the path to the image is correct
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Black overlay with opacity
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  onChanged: _validateInputs,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Macro Calculator',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Macros are confusing. However, macros are a crucial part of your nutrition.\nThis tool will help you set up the roadmap for your dietary needs.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Form Fields
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        style: TextStyle(color: Colors.white),
                                        value: _sex,
                                        decoration: InputDecoration(
                                          labelText: 'Sex',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
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
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        controller: _ageController,
                                        decoration: InputDecoration(
                                          labelText: 'Age',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
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
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        cursorColor: Colors.white,
                                        controller: _heightController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Height (inches)',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
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
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        controller: _weightController,
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Weight (lbs)',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter weight';
                                          }
                                          if (double.tryParse(value) == null) {
                                            return 'Please enter a valid number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Divider(color: Colors.white),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  style: TextStyle(color: Colors.white),
                                  value: _activityLevel,
                                  decoration: const InputDecoration(
                                    labelText: 'What is your activity level',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _isButtonEnabled ? () {} : null,
                        child: SizedBox(
                          width: 280, // Set the desired width here
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: BoxDecoration(
                              color:
                                  _isButtonEnabled ? Colors.white : Colors.grey,
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
                      const SizedBox(height: 20),
                      // Container(
                      //   padding: EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: Colors.black.withOpacity(0.7),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: MacroDisplayWidget(
                      //     calories: '1700',
                      //     carbs: '200',
                      //     protein: '160',
                      //     fats: '50',
                      //     borderColor: Colors.white, // Change border color here
                      //     textColor: Colors.white, // Change text color here
                      //     button: false,
                      //   ),
                      // ),
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
}
