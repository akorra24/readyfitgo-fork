import 'package:flutter/material.dart';
import 'package:website/pages/macro_calculator_page.dart';
import 'package:website/pages/meal_generator_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background image
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/steak.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Add shadow to the background image
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [Color(0x8C0B1D26), Colors.transparent],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Color(0xFF0B1D26), Colors.transparent],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      // Navigation Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
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
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Calculate Macros",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Meal Generator",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
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
                      Spacer(),
                      // Central Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Fit your budget.",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Fit your lifestyle.",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  // Button press action here
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white, // Text color
                                  backgroundColor:
                                      Colors.black54, // Background color
                                  side: const BorderSide(
                                    color: Colors.white, // Border color
                                    width: 1.0, // Border width
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Button corner radius
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Calculate Macros'),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              OutlinedButton(
                                onPressed: () {
                                  // Button press action here
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white, // Text color
                                  backgroundColor:
                                      Colors.black54, // Background color
                                  side: const BorderSide(
                                    color: Colors.white, // Border color
                                    width: 1.0, // Border width
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Button corner radius
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Meal Generator'),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                // Side Icons
                Positioned(
                  left: 20,
                  top: 200,
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Features Section
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                children: [
                  // Text Section
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Numbered Header
                        Row(
                          children: [
                            Text(
                              "01",
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white.withOpacity(0.1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "GET STARTED",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Main Title
                        Text(
                          "Nutrition",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Bullet Points
                        Text(
                          "1. Start monitoring your food intake for at least a month.\n   • You don’t have to do this forever.\n   • You’re doing this to get a rough idea of how many calories are in your food.\n"
                          "\n2. Estimate your calories using the macro calculator.\n   • If you’re not already super lean (<12% body fat), start with a cut.\n   • This will fast-track your aesthetics progress by shedding fat.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Image Section
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Image.asset(
                          'images/nutrition.png',
                          width: 300,
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Features Section
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                children: [
                  // Image Section
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Image.asset(
                          'images/nutrition.png',
                          width: 300,
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Text Section
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Numbered Header
                        Row(
                          children: [
                            Text(
                              "01",
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white.withOpacity(0.1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "GET STARTED",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Main Title
                        Text(
                          "Nutrition",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Bullet Points
                        Text(
                          "1. Start monitoring your food intake for at least a month.\n   • You don’t have to do this forever.\n   • You’re doing this to get a rough idea of how many calories are in your food.\n"
                          "\n2. Estimate your calories using the macro calculator.\n   • If you’re not already super lean (<12% body fat), start with a cut.\n   • This will fast-track your aesthetics progress by shedding fat.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Features Section
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                children: [
                  // Text Section
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Numbered Header
                        Row(
                          children: [
                            Text(
                              "01",
                              style: TextStyle(
                                fontSize: 50,
                                color: Colors.white.withOpacity(0.1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "GET STARTED",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Main Title
                        Text(
                          "Nutrition",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Bullet Points
                        Text(
                          "1. Start monitoring your food intake for at least a month.\n   • You don’t have to do this forever.\n   • You’re doing this to get a rough idea of how many calories are in your food.\n"
                          "\n2. Estimate your calories using the macro calculator.\n   • If you’re not already super lean (<12% body fat), start with a cut.\n   • This will fast-track your aesthetics progress by shedding fat.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Image Section
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Image.asset(
                          'images/nutrition.png',
                          width: 300,
                          height: 400,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
