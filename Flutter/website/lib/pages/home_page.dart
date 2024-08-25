import 'package:flutter/material.dart';
import 'package:website/pages/macro_calculator_page.dart';
import 'package:website/pages/meal_generator_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  'images/steak.jpg', // Background image
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  color:
                      Colors.black.withOpacity(0.5), // Adjust overlay opacity
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '1025 Pacific Coast Hwy, Hermosa Beach, CA 90254',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Rufina'),
                      ),
                      Text(
                        '(310) 318-3188',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Rufina'),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30, // Adjust top padding to center logo better
                  left: 20,
                  child: Image.asset(
                    'images/rfgg.png', // Path to the logo image
                    width: 150, // Increase width to make the logo bigger
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Fit your budget.\nFit your lifestyle.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48, // Increase font size
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rufina', // Use Rufina font
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MealGenerator()),
                              );
                            },
                            child: Container(
                              width: 200, // Adjust width for larger buttons
                              padding: const EdgeInsets.all(16),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Make the background transparent
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0, // Add white border to match Figma
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Meal Generator',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        18, // Increase font size for buttons
                                    fontFamily: 'Rufina', // Use Rufina font
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MacroCalculatorPage()),
                              );
                            },
                            child: Container(
                              width: 200, // Adjust width for larger buttons
                              padding: const EdgeInsets.all(16),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors
                                    .transparent, // Make the background transparent
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0, // Add white border to match Figma
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Macro Calculator',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        18, // Increase font size for buttons
                                    fontFamily: 'Rufina', // Use Rufina font
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(
                0xFF003300), // Dark green banner background (adjust color as needed)
            padding: const EdgeInsets.all(
                30), // Increase padding to make the banner taller
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready Fit Go',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Rufina'),
                    ),
                    Text(
                      '1025 Pacific Coast Hwy,\nHermosa Beach, CA 90254',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Rufina'),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Rufina'),
                    ),
                    Text(
                      '(310) 318-3188',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Rufina'),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Website',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Rufina'),
                    ),
                    Text(
                      'readyfitgo.com',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Rufina'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
