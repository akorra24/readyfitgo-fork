import 'package:flutter/material.dart';
import 'package:website/pages/daily_meal_page_2.dart';
import 'package:website/pages/home_page.dart';
import 'package:website/pages/meal_generator_page.dart';
import 'dart:html' as html;

void main() {
  runApp(MaterialApp(home: MacroCalculatorPage()));
}

class MacroCalculatorPage extends StatefulWidget {
  @override
  _MacroCalculatorPageState createState() => _MacroCalculatorPageState();
}

class _MacroCalculatorPageState extends State<MacroCalculatorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _buildNavigation(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).size.width < 700) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          );
        } else {
          return Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.03),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
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
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.03),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MacroCalculatorPage()),
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
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.03),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealGenerator()),
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
                  backgroundColor: Colors.transparent, // Background color
                  side: const BorderSide(
                    color: Colors.white, // Border color
                    width: 1.0, // Border width
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Button corner radius
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      html.window.open('https://readyfitgo.com/shop', '_blank');
                    },
                    child: Text(
                      'Shop Now',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

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
  String _activityLevel = 'Lightly active';
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
      case 'Sedentary':
        if (_fitnessGoal == 'Lose Weight') {
          multiplier =
              10; // or maybe 10, as it’s even below the Lightly Active 10–12 range
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 12; // slightly lower than Lightly Active 12–14
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 14; // or 15, your choice
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 11; // slightly less than your lose-weight number
        } else {
          multiplier = 12; // fallback
        }
        break;
      case 'Lightly active':
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
      case 'Moderately active':
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
      case 'Very active':
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
      case 'Super active':
        // If you want to handle super active similarly:
        if (_fitnessGoal == 'Lose Weight') {
          multiplier = 17; // e.g., a bit higher than Very Active’s 15
        } else if (_fitnessGoal == 'Maintain Weight') {
          multiplier = 19; // or maybe 20
        } else if (_fitnessGoal == 'Gain Weight') {
          multiplier = 22; // or 24, etc.
        } else if (_fitnessGoal == 'Body Recomposition') {
          multiplier = 18;
        } else {
          multiplier = 19;
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
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: const Text('Calculate Macros'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MacroCalculatorPage()));
              },
            ),
            ListTile(
              title: const Text('Meal Generator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MealGenerator()));
              },
            ),
            ListTile(
              title: const Text('Shop Now'),
              onTap: () {
                html.window.open('https://readyfitgo.com/shop', '_blank');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Navigation Bar
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'images/logo.png',
                                height: 50,
                              ),
                              _buildNavigation(context),
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
                padding: const EdgeInsets.all(20),
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
                    const SizedBox(height: 20),
                    // Body Composition Form
                    Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF172B32),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              onChanged: _validateInputs,
                              child: Column(
                                children: [
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (constraints.maxWidth < 700) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Body Composition',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child:
                                                              DropdownButtonFormField<
                                                                  String>(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                            value: _sex,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText: 'Sex',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF112025),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                            ),
                                                            dropdownColor:
                                                                Colors
                                                                    .grey[800],
                                                            items: [
                                                              'Male',
                                                              'Female'
                                                            ]
                                                                .map((label) =>
                                                                    DropdownMenuItem(
                                                                      child: Text(
                                                                          label),
                                                                      value:
                                                                          label,
                                                                    ))
                                                                .toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _sex = value!;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10),
                                                          child: TextFormField(
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                            cursorColor:
                                                                Colors.white,
                                                            controller:
                                                                _heightController,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Height (inches)',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF112025),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter height';
                                                              }
                                                              if (double.tryParse(
                                                                      value) ==
                                                                  null) {
                                                                return 'Please enter a valid number';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10),
                                                          child:
                                                              DropdownButtonFormField<
                                                                  String>(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                            value:
                                                                _activityLevel,
                                                            isExpanded: true,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Activity level',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF112025),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                            ),
                                                            dropdownColor:
                                                                Colors
                                                                    .grey[800],
                                                            items: [
                                                              'Sedentary',
                                                              'Lightly active',
                                                              'Moderately active',
                                                              'Very active',
                                                              'Super active'
                                                            ]
                                                                .map((label) =>
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        label,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      value:
                                                                          label,
                                                                    ))
                                                                .toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _activityLevel =
                                                                    value!;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                            controller:
                                                                _ageController,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText: 'Age',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF112025),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter age';
                                                              }
                                                              if (double.tryParse(
                                                                      value) ==
                                                                  null) {
                                                                return 'Please enter a valid number';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10),
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                            controller:
                                                                _weightController,
                                                            cursorColor:
                                                                Colors.white,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Enter Weight (lbs)',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF112025),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter a valid number';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10),
                                                          child:
                                                              DropdownButtonFormField<
                                                                  String>(
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                            value: _fitnessGoal,
                                                            isExpanded: true,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Fitness Goals',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              filled: true,
                                                              fillColor: Color(
                                                                  0xFF112025),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            185,
                                                                            255,
                                                                            255,
                                                                            255)),
                                                              ),
                                                            ),
                                                            dropdownColor:
                                                                Colors
                                                                    .grey[800],
                                                            items: [
                                                              'Lose Weight',
                                                              'Maintain Weight',
                                                              'Gain Weight',
                                                              'Body Recomposition',
                                                            ]
                                                                .map((label) =>
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        label,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      value:
                                                                          label,
                                                                    ))
                                                                .toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _fitnessGoal =
                                                                    value!;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Meal Preferences',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  value: _dietaryPreference,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Dietary Preference',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFF112025),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  dropdownColor:
                                                      Colors.grey[800],
                                                  items: [
                                                    'None',
                                                    'Vegetarian',
                                                    'Vegan'
                                                  ]
                                                      .map((label) =>
                                                          DropdownMenuItem(
                                                            child: Text(label),
                                                            value: label,
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _dietaryPreference =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: DropdownButtonFormField<
                                                    int>(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  value: _numberOfMeals,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Number of Meals per Day',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFF112025),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  dropdownColor:
                                                      Colors.grey[800],
                                                  items: List.generate(6,
                                                          (index) => index + 1)
                                                      .map((label) =>
                                                          DropdownMenuItem(
                                                            child:
                                                                Text('$label'),
                                                            value: label,
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _numberOfMeals = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: DropdownButtonFormField<
                                                    int>(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  value: _numberOfDays,
                                                  isExpanded: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Number of Days',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFF112025),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  dropdownColor:
                                                      Colors.grey[800],
                                                  items: List.generate(7,
                                                          (index) => index + 1)
                                                      .map((label) =>
                                                          DropdownMenuItem(
                                                            child: Text(
                                                              '$label',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            value: label,
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _numberOfDays = value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Macro Proportions',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  controller:
                                                      _proteinPercentageController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Protein (%)',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFF112025),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter protein %';
                                                    }
                                                    if (double.tryParse(
                                                            value) ==
                                                        null) {
                                                      return 'Enter a valid number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  controller:
                                                      _carbsPercentageController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Carbs (%)',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFF112025),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter carbs %';
                                                    }
                                                    if (double.tryParse(
                                                            value) ==
                                                        null) {
                                                      return 'Enter a valid number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  controller:
                                                      _fatPercentageController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Fat (%)',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Color(0xFF112025),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
                                                              185,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter fat %';
                                                    }
                                                    if (double.tryParse(
                                                            value) ==
                                                        null) {
                                                      return 'Enter a valid number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Body Composition',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                DropdownButtonFormField<
                                                                    String>(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              value: _sex,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Sex',
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(
                                                                    0xFF112025),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                              ),
                                                              dropdownColor:
                                                                  Colors.grey[
                                                                      800],
                                                              items: [
                                                                'Male',
                                                                'Female'
                                                              ]
                                                                  .map((label) =>
                                                                      DropdownMenuItem(
                                                                        child: Text(
                                                                            label),
                                                                        value:
                                                                            label,
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _sex = value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child:
                                                                TextFormField(
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              cursorColor:
                                                                  Colors.white,
                                                              controller:
                                                                  _heightController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Height (inches)',
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(
                                                                    0xFF112025),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter height';
                                                                }
                                                                if (double.tryParse(
                                                                        value) ==
                                                                    null) {
                                                                  return 'Please enter a valid number';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child:
                                                                DropdownButtonFormField<
                                                                    String>(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              value:
                                                                  _activityLevel,
                                                              isExpanded: true,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Activity level',
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(
                                                                    0xFF112025),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                              ),
                                                              dropdownColor:
                                                                  Colors.grey[
                                                                      800],
                                                              items: [
                                                                'Sedentary',
                                                                'Lightly active',
                                                                'Moderately active',
                                                                'Very active',
                                                                'Super active'
                                                              ]
                                                                  .map((label) =>
                                                                      DropdownMenuItem(
                                                                        child:
                                                                            Text(
                                                                          label,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        value:
                                                                            label,
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _activityLevel =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Expanded(
                                                        child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              controller:
                                                                  _ageController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Age',
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(
                                                                    0xFF112025),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter age';
                                                                }
                                                                if (double.tryParse(
                                                                        value) ==
                                                                    null) {
                                                                  return 'Please enter a valid number';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child:
                                                                TextFormField(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              controller:
                                                                  _weightController,
                                                              cursorColor:
                                                                  Colors.white,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Enter Weight (lbs)',
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(
                                                                    0xFF112025),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                              ),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter a valid number';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 10),
                                                            child:
                                                                DropdownButtonFormField<
                                                                    String>(
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                              value:
                                                                  _fitnessGoal,
                                                              isExpanded: true,
                                                              decoration:
                                                                  const InputDecoration(
                                                                labelText:
                                                                    'Fitness Goals',
                                                                labelStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 13,
                                                                ),
                                                                filled: true,
                                                                fillColor: Color(
                                                                    0xFF112025),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          185,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                                ),
                                                              ),
                                                              dropdownColor:
                                                                  Colors.grey[
                                                                      800],
                                                              items: [
                                                                'Lose Weight',
                                                                'Maintain Weight',
                                                                'Gain Weight',
                                                                'Body Recomposition',
                                                              ]
                                                                  .map((label) =>
                                                                      DropdownMenuItem(
                                                                        child:
                                                                            Text(
                                                                          label,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                        value:
                                                                            label,
                                                                      ))
                                                                  .toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _fitnessGoal =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Meal Preferences',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    value: _dietaryPreference,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Dietary Preference',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF112025),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                    ),
                                                    dropdownColor:
                                                        Colors.grey[800],
                                                    items: [
                                                      'None',
                                                      'Vegetarian',
                                                      'Vegan'
                                                    ]
                                                        .map((label) =>
                                                            DropdownMenuItem(
                                                              child:
                                                                  Text(label),
                                                              value: label,
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _dietaryPreference =
                                                            value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child:
                                                      DropdownButtonFormField<
                                                          int>(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    value: _numberOfMeals,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Number of Meals per Day',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF112025),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                    ),
                                                    dropdownColor:
                                                        Colors.grey[800],
                                                    items: List.generate(
                                                            6,
                                                            (index) =>
                                                                index + 1)
                                                        .map((label) =>
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                  '$label'),
                                                              value: label,
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _numberOfMeals = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child:
                                                      DropdownButtonFormField<
                                                          int>(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    value: _numberOfDays,
                                                    isExpanded: true,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'Number of Days',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF112025),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                    ),
                                                    dropdownColor:
                                                        Colors.grey[800],
                                                    items: List.generate(
                                                            7,
                                                            (index) =>
                                                                index + 1)
                                                        .map((label) =>
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                '$label',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              value: label,
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _numberOfDays = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Macro Proportions',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    controller:
                                                        _proteinPercentageController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Protein (%)',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF112025),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Enter protein %';
                                                      }
                                                      if (double.tryParse(
                                                              value) ==
                                                          null) {
                                                        return 'Enter a valid number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    controller:
                                                        _carbsPercentageController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Carbs (%)',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF112025),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Enter carbs %';
                                                      }
                                                      if (double.tryParse(
                                                              value) ==
                                                          null) {
                                                        return 'Enter a valid number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                    ),
                                                    controller:
                                                        _fatPercentageController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Fat (%)',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Color(0xFF112025),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    185,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Enter fat %';
                                                      }
                                                      if (double.tryParse(
                                                              value) ==
                                                          null) {
                                                        return 'Enter a valid number';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                                  if (_macroError != null)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        _macroError!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  const SizedBox(height: 40),
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (constraints.maxWidth < 700) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _isButtonEnabled
                                                ? () {
                                                    if (_formKey.currentState
                                                            ?.validate() ??
                                                        false) {
                                                      _calculateMacros();
                                                    }
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _isButtonEnabled
                                                  ? const Color(0xFF0C1F27)
                                                  : Colors.grey,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child:
                                                const Text('Calculate Macros'),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: _isButtonEnabled
                                                ? () {
                                                    if (_formKey.currentState
                                                            ?.validate() ??
                                                        false) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DailyMealPlanPage(
                                                            age: int.tryParse(
                                                                _ageController
                                                                    .text),
                                                            sex: _sex,
                                                            height: double.tryParse(
                                                                _heightController
                                                                    .text),
                                                            weight: double.tryParse(
                                                                _weightController
                                                                    .text),
                                                            activityLevel:
                                                                _activityLevel,
                                                            fitnessGoal:
                                                                _fitnessGoal,
                                                            dietaryPreference:
                                                                _dietaryPreference,
                                                            numberOfMeals:
                                                                _numberOfMeals,
                                                            numberOfDays:
                                                                _numberOfDays,
                                                            proteinPercentage:
                                                                double.parse(
                                                                    _proteinPercentageController
                                                                        .text),
                                                            carbsPercentage:
                                                                double.parse(
                                                                    _carbsPercentageController
                                                                        .text),
                                                            fatPercentage:
                                                                double.parse(
                                                                    _fatPercentageController
                                                                        .text),
                                                            calculateMacros:
                                                                true, // Assuming this flag triggers macro calculation
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                : null,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _isButtonEnabled
                                                  ? const Color(0xFF0C1F27)
                                                  : Colors.grey,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text('Generate Meals'),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    10.0), // Add horizontal padding
                                            child: ElevatedButton(
                                              onPressed: _isButtonEnabled
                                                  ? () {
                                                      if (_formKey.currentState
                                                              ?.validate() ??
                                                          false) {
                                                        _calculateMacros();
                                                      }
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    _isButtonEnabled
                                                        ? const Color(
                                                            0xFF0C1F27)
                                                        : Colors.grey,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Text(
                                                  'Calculate Macros'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    10.0), // Add horizontal padding
                                            child: ElevatedButton(
                                              onPressed: _isButtonEnabled
                                                  ? () {
                                                      if (_formKey.currentState
                                                              ?.validate() ??
                                                          false) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                DailyMealPlanPage(
                                                              age: int.tryParse(
                                                                  _ageController
                                                                      .text),
                                                              sex: _sex,
                                                              height: double
                                                                  .tryParse(
                                                                      _heightController
                                                                          .text),
                                                              weight: double
                                                                  .tryParse(
                                                                      _weightController
                                                                          .text),
                                                              activityLevel:
                                                                  _activityLevel,
                                                              fitnessGoal:
                                                                  _fitnessGoal,
                                                              dietaryPreference:
                                                                  _dietaryPreference,
                                                              numberOfMeals:
                                                                  _numberOfMeals,
                                                              numberOfDays:
                                                                  _numberOfDays,
                                                              proteinPercentage:
                                                                  double.parse(
                                                                      _proteinPercentageController
                                                                          .text),
                                                              carbsPercentage:
                                                                  double.parse(
                                                                      _carbsPercentageController
                                                                          .text),
                                                              fatPercentage:
                                                                  double.parse(
                                                                      _fatPercentageController
                                                                          .text),
                                                              calculateMacros:
                                                                  true, // Assuming this flag triggers macro calculation
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    _isButtonEnabled
                                                        ? const Color(
                                                            0xFF0C1F27)
                                                        : Colors.grey,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child:
                                                  const Text('Generate Meals'),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Daily Macros
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: Column(children: [
                                const Text(
                                  'Daily Macros',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                LayoutBuilder(builder: (context, constraints) {
                                  if (MediaQuery.of(context).size.width < 700) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  'Calories',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  _macrosCalculated
                                                      ? '${_calories.toStringAsFixed(0)} cal'
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  'Protein',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  _macrosCalculated
                                                      ? '${_protein.toStringAsFixed(0)} g'
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                const Text(
                                                  'Carbs',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  _macrosCalculated
                                                      ? '${_carbs.toStringAsFixed(0)} g'
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Text(
                                                  'Fats',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  _macrosCalculated
                                                      ? '${_fats.toStringAsFixed(0)} g'
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'Calories',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _macrosCalculated
                                                  ? '${_calories.toStringAsFixed(0)} cal'
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Protein',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _macrosCalculated
                                                  ? '${_protein.toStringAsFixed(0)} g'
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Carbs',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _macrosCalculated
                                                  ? '${_carbs.toStringAsFixed(0)} g'
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Fats',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _macrosCalculated
                                                  ? '${_fats.toStringAsFixed(0)} g'
                                                  : "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                }),
                              ]),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "images/home_line.png",
                          width: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "MODIFIERS",
                          style: TextStyle(
                            fontFamily: 'Rufina',
                            fontSize: 15,
                            letterSpacing: 5,
                            color: Color(0xFFFBD784),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    // Main Title
                    Text(
                      "Activity Level",
                      style: TextStyle(
                        fontFamily: 'Rufina',
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Important: most people tend to overestimate their activity level.",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "This is usually due to them basing their activity level on their number of gym sessions per week. This is not the right way to go about it.",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "If your only activity outside the office is the gym, put yourself down as “Sedentary”. ",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Your activity level is primarily based on what you do outside the gym.",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Four 1 hour strength training sessions at the gym each week is less than 2 hours of actual activity. It does not result in a large number of calories burnt.\nConversely, a teacher on her feet for the lions share of the week is most likely “Lightly Active”. The intermittent cardio throughout the day adds up.",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "You might be slightly over depending on your intensity and frequency – but more likely you won’t be. You can adjust your estimate based on the first couple of week’s progress. If you think you’re on the line between levels and it could go either way – go with the lower estimate.",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "The Activity Level modifiers are:",
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          "• Sedentary: Little or no exercise, office job (1.2×)",
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          "• Lightly Active: Light daily activity & exercise 1-3 days per week (1.375×)",
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          "• Moderately Active: Moderate daily activity & exercise 3-5 days per week (1.55×)",
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          "• Very Active: Physically demanding lifestyle & exercise 6-7 days per week (1.725×)",
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          "• Extremely Active: Hard daily exercise/sports & physical job (1.9×)",
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMacroCard(String label, double value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '${value.toStringAsFixed(0)} $unit',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
