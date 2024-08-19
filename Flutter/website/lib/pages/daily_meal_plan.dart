// // import 'package:flutter/material.dart';
// import 'package:website/pages/breakfast_page.dart';

// import 'package:flutter/material.dart';

// class DailyMealPlanPage extends StatefulWidget {
//   final double calories;
//   final double carbs;
//   final double protein;
//   final double fats;
//   final String dietaryPreference;
//   final int numberOfMeals;
//   final int numberOfDays;

//   const DailyMealPlanPage({
//     Key? key,
//     required this.calories,
//     required this.carbs,
//     required this.protein,
//     required this.fats,
//     required this.dietaryPreference,
//     required this.numberOfMeals,
//     required this.numberOfDays,
//   }) : super(key: key);

//   @override
//   _DailyMealPlanPageState createState() => _DailyMealPlanPageState();
// }

// class _DailyMealPlanPageState extends State<DailyMealPlanPage>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(vsync: this, length: widget.numberOfDays);
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Meal Plans for the Week'),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor:
//               Colors.green, // Color of the tab indicator (underline)
//           labelColor: Colors.green, // Color of the selected tab
//           unselectedLabelColor: Colors.grey, // Color of the unselected tabs
//           tabs: List<Widget>.generate(
//             widget.numberOfDays,
//             (index) => Tab(text: 'Day ${index + 1}'),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: List<Widget>.generate(
//           widget.numberOfDays,
//           (index) => MealRecommendationPage(
//             key: PageStorageKey('Day$index'),
//             dayIndex: index,
//             calories: widget.calories,
//             carbs: widget.carbs,
//             protein: widget.protein,
//             fats: widget.fats,
//             dietaryPreference: widget.dietaryPreference,
//             numberOfMeals: widget.numberOfMeals,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class DailyMealPlanPage extends StatefulWidget {
// //   final double calories;
// //   final double carbs;
// //   final double protein;
// //   final double fats;
// //   final String dietaryPreference;
// //   final int numberOfMeals;
// //   final int numberOfDays;

// //   const DailyMealPlanPage({
// //     Key? key,
// //     required this.calories,
// //     required this.carbs,
// //     required this.protein,
// //     required this.fats,
// //     required this.dietaryPreference,
// //     required this.numberOfMeals,
// //     required this.numberOfDays,
// //   }) : super(key: key);

// //   @override
// //   _DailyMealPlanPageState createState() => _DailyMealPlanPageState();
// // }

// // class _DailyMealPlanPageState extends State<DailyMealPlanPage>
// //     with SingleTickerProviderStateMixin {
// //   TabController? _tabController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(vsync: this, length: widget.numberOfDays);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Meal Plans for the Week'),
// //         bottom: TabBar(
// //           controller: _tabController,
// //           tabs: List<Widget>.generate(
// //               widget.numberOfDays, (index) => Tab(text: 'Day ${index + 1}')),
// //         ),
// //       ),
// //       body: TabBarView(
// //         controller: _tabController,
// //         children: List<Widget>.generate(
// //             widget.numberOfDays,
// //             (index) => MealRecommendationPage(
// //                 key: PageStorageKey('Day$index'), // Assign unique keys
// //                 dayIndex: index)),
// //       ),
// //     );
// //   }
// // }
