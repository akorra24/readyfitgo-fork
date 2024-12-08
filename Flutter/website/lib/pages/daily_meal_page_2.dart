import 'package:flutter/material.dart';
import 'package:website/pages/breakfast_page.dart';

class DailyMealPlanPage extends StatefulWidget {
  final int? age;
  final String? sex;
  final double? height;
  final double? weight;
  final String? activityLevel;
  final String? fitnessGoal;
  final Map<String, double>? selectedMacros;
  final String dietaryPreference;
  final int numberOfMeals;
  final int numberOfDays;
  final bool calculateMacros;
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatPercentage;

  const DailyMealPlanPage({
    Key? key,
    this.age,
    this.sex,
    this.height,
    this.weight,
    this.activityLevel,
    this.fitnessGoal,
    this.selectedMacros,
    required this.dietaryPreference,
    required this.numberOfMeals,
    required this.numberOfDays,
    required this.calculateMacros,
    this.proteinPercentage = 35,
    this.carbsPercentage = 35,
    this.fatPercentage = 30,
  }) : super(key: key);

  @override
  _DailyMealPlanPageState createState() => _DailyMealPlanPageState();
}

class _DailyMealPlanPageState extends State<DailyMealPlanPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  double dailyCaloricNeeds = 0; // Initialize with a default value
  Map<String, double> dailyMacros = {
    'Protein (grams)': 0,
    'Carbs (grams)': 0,
    'Fats (grams)': 0,
  }; // Initialize with default values

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.numberOfDays);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.calculateMacros) {
        calculateMacros();
      } else {
        dailyCaloricNeeds = widget.selectedMacros?['Calories'] ?? 0;
        dailyMacros = {
          'Protein (grams)': widget.selectedMacros?['Protein'] ?? 0,
          'Carbs (grams)': widget.selectedMacros?['Carbohydrates'] ?? 0,
          'Fats (grams)': widget.selectedMacros?['Fats'] ?? 0,
        };
        if (mounted) setState(() {});
      }
    });
  }

  void calculateMacros() {
    if (widget.age == null ||
        widget.sex == null ||
        widget.height == null ||
        widget.weight == null ||
        widget.activityLevel == null ||
        widget.fitnessGoal == null) {
      // Handle the error case where essential parameters are missing
      return;
    }

    double multiplier;
    switch (widget.activityLevel) {
      case 'Lightly active (light exercise less than 3 days per week)':
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
      case 'Moderately active (moderate exercise 3-5 days per week)':
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
      case 'Very active (intense exercise 6-7 days per week)':
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
      default:
        multiplier =
            13; // default to maintenance if activity level is not specified
    }

    dailyCaloricNeeds = widget.weight! * multiplier;

    dailyMacros = {
      'Protein (grams)': dailyCaloricNeeds *
          (widget.selectedMacros?['Protein'] ?? widget.proteinPercentage) /
          100 /
          4,
      'Carbs (grams)': dailyCaloricNeeds *
          (widget.selectedMacros?['Carbohydrates'] ?? widget.carbsPercentage) /
          100 /
          4,
      'Fats (grams)': dailyCaloricNeeds *
          (widget.selectedMacros?['Fats'] ?? widget.fatPercentage) /
          100 /
          9,
    };

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (dailyCaloricNeeds == 0 || dailyMacros.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        color: Color(0xFF0C1F27),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                SizedBox(height: 40), // Add some space at the top if needed
                TabBar(
                  labelStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: List<Widget>.generate(
                    widget.numberOfDays,
                    (index) => Tab(text: 'Day ${index + 1}'),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List<Widget>.generate(
                      widget.numberOfDays,
                      (index) => MealRecommendationPage(
                        key: PageStorageKey('Day$index'),
                        dayIndex: index,
                        calories: dailyCaloricNeeds,
                        carbs: dailyMacros['Carbs (grams)']!,
                        protein: dailyMacros['Protein (grams)']!,
                        fats: dailyMacros['Fats (grams)']!,
                        dietaryPreference: widget.dietaryPreference,
                        numberOfMeals: widget.numberOfMeals,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
