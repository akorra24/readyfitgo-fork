import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final int age;
  final String sex;
  final double height;
  final double weight;
  final String activityLevel;
  final String fitnessGoal;
  final Map<String, double> selectedMacros;

  ResultsPage({
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.fitnessGoal,
    required this.selectedMacros,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  double? dailyCaloricNeeds;
  Map<String, double>? dailyMacros;

  @override
  void initState() {
    super.initState();
    calculateMacros();
  }

  void calculateMacros() {
    // Determine the multiplier based on activity level and fitness goal
    double multiplier;
    print(widget.activityLevel);
    switch (widget.activityLevel) {
      case 'Sedentary':
        if (widget.fitnessGoal == 'Lose Weight') {
          multiplier =
              10; // or maybe 10, as it’s even below the Lightly Active 10–12 range
        } else if (widget.fitnessGoal == 'Maintain Weight') {
          multiplier = 12; // slightly lower than Lightly Active 12–14
        } else if (widget.fitnessGoal == 'Gain Weight') {
          multiplier = 14; // or 15, your choice
        } else if (widget.fitnessGoal == 'Body Recomposition') {
          multiplier = 11; // slightly less than your lose-weight number
        } else {
          multiplier = 12; // fallback
        }
        break;
      case 'Lightly active':
        if (widget.fitnessGoal == 'Lose Weight') {
          multiplier = 11; // middle of the range 10-12
        } else if (widget.fitnessGoal == 'Maintain Weight') {
          multiplier = 13; // middle of the range 12-14
        } else if (widget.fitnessGoal == 'Gain Weight') {
          multiplier = 16; // middle of the range 16-18
        } else if (widget.fitnessGoal == 'Body Recomposition') {
          multiplier = 12; // slightly less than maintenance
        } else {
          multiplier = 13; // default to maintenance if goal is not specified
        }
        break;
      case 'Moderately active':
        if (widget.fitnessGoal == 'Lose Weight') {
          multiplier = 13; // middle of the range 12-14
        } else if (widget.fitnessGoal == 'Maintain Weight') {
          multiplier = 15; // middle of the range 14-16
        } else if (widget.fitnessGoal == 'Gain Weight') {
          multiplier = 18; // middle of the range 18-20
        } else if (widget.fitnessGoal == 'Body Recomposition') {
          multiplier = 14; // slightly less than maintenance
        } else {
          multiplier = 15; // default to maintenance if goal is not specified
        }
        break;
      case 'Very active':
        if (widget.fitnessGoal == 'Lose Weight') {
          multiplier = 15; // middle of the range 14-16
        } else if (widget.fitnessGoal == 'Maintain Weight') {
          multiplier = 17; // middle of the range 16-18
        } else if (widget.fitnessGoal == 'Gain Weight') {
          multiplier = 20; // middle of the range 20-22
        } else if (widget.fitnessGoal == 'Body Recomposition') {
          multiplier = 16; // slightly less than maintenance
        } else {
          multiplier = 17; // default to maintenance if goal is not specified
        }
        break;
      case 'Super active':
        // If you want to handle super active similarly:
        if (widget.fitnessGoal == 'Lose Weight') {
          multiplier = 17; // e.g., a bit higher than Very Active’s 15
        } else if (widget.fitnessGoal == 'Maintain Weight') {
          multiplier = 19; // or maybe 20
        } else if (widget.fitnessGoal == 'Gain Weight') {
          multiplier = 22; // or 24, etc.
        } else if (widget.fitnessGoal == 'Body Recomposition') {
          multiplier = 18;
        } else {
          multiplier = 19;
        }
        break;
      default:
        multiplier =
            13; // default to maintenance if activity level is not specified
    }

    // Calculate daily caloric needs
    dailyCaloricNeeds = widget.weight * multiplier;

    // Calculate macros based on selected preferences
    dailyMacros = {
      'Protein (grams)': dailyCaloricNeeds! *
          (widget.selectedMacros['Protein'] ?? 25.0) /
          100 /
          4,
      'Carbs (grams)': dailyCaloricNeeds! *
          (widget.selectedMacros['Carbohydrates'] ?? 50.0) /
          100 /
          4,
      'Fats (grams)': dailyCaloricNeeds! *
          (widget.selectedMacros['Fats'] ?? 25.0) /
          100 /
          9,
    };
  }
  // void calculateMacros() {
  //   // Example calculation function - You will need to implement the actual logic based on the user's inputs
  //   double bmr;
  //   if (widget.sex == 'Male') {
  //     bmr = 88.362 +
  //         (13.397 * widget.weight) +
  //         (4.799 * widget.height) -
  //         (5.677 * widget.age);
  //   } else {
  //     bmr = 447.593 +
  //         (9.247 * widget.weight) +
  //         (3.098 * widget.height) -
  //         (4.330 * widget.age);
  //   }
  //   // Adjust bmr based on activity level
  //   switch (widget.activityLevel) {
  //     case 'Lightly active (light exercise less than 3 days per week)':
  //       dailyCaloricNeeds = bmr * 1.2;
  //       break;
  //     case 'Moderately active (moderate exercise 3-5 days per week)':
  //       dailyCaloricNeeds = bmr * 1.55;
  //       break;
  //     case 'Very active (intense exercise 6-7 days per week)':
  //       dailyCaloricNeeds = bmr * 1.725;
  //       break;
  //     default:
  //       dailyCaloricNeeds = bmr * 1.2;
  //   }

  //   // Calculate macros based on selected preferences
  //   dailyMacros = {
  //     'Protein (grams)':
  //         dailyCaloricNeeds! * widget.selectedMacros['Protein']! / 100 / 4,
  //     'Carbs (grams)': dailyCaloricNeeds! *
  //         widget.selectedMacros['Carbohydrates']! /
  //         100 /
  //         4,
  //     'Fats (grams)':
  //         dailyCaloricNeeds! * widget.selectedMacros['Fats']! / 100 / 9,
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Daily Macros'),
      ),
      body: Center(
        child: dailyMacros == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Daily Calories: ${dailyCaloricNeeds!.toStringAsFixed(2)}'),
                  Text(
                      'Protein: ${dailyMacros!['Protein (grams)']!.toStringAsFixed(2)} grams'),
                  Text(
                      'Carbohydrates: ${dailyMacros!['Carbs (grams)']!.toStringAsFixed(2)} grams'),
                  Text(
                      'Fats: ${dailyMacros!['Fats (grams)']!.toStringAsFixed(2)} grams'),
                ],
              ),
      ),
    );
  }
}
