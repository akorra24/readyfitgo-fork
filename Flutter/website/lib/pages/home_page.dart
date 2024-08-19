import 'package:flutter/material.dart';
import 'package:website/pages/macro_calculator_page.dart';
// import 'package:website/pages/macro_calculator_page.dart';
import 'package:website/pages/meal_generator_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
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
          const Positioned(
            top: 50,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  '1025 Pacific Coast Hwy, Hermosa Beach, CA 90254',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '(310) 318-3188',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Personalised Nutrition Partner.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: const Text(
                    'Simply input your desired macros, number of meals, and days for the plan. \nOur AI system handles the rest, delivering a meal plan for each day that best matches your macros.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealGenerator()),
                    );
                  },
                  child: SizedBox(
                    width: 240, // Set the desired width here
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    width: 240, // Set the desired width here
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Macro Calculator',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 30,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ready Fit Go',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  '1025 Pacific Coast Hwy,\nHermosa Beach, CA 90254',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'Contact',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  '(310) 318-3188',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            right: screenWidth / 2 - 40,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Website',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  'readyfitgo.com',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
