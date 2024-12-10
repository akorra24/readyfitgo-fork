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
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MealGenerator()),
                                    );
                                  },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "images/home_line.png",
                                    width: 80,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Ready Fit Go",
                                    style: TextStyle(
                                      fontFamily: 'Rufina',
                                      fontSize: 20,
                                      color: Color(0xFFFBD784),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "Fit your budget.",
                                style: TextStyle(
                                  fontFamily: 'Rufina',
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Fit your lifestyle.",
                                style: TextStyle(
                                  fontFamily: 'Rufina',
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MacroCalculatorPage()),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          Colors.white, // Text color
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Calculate Macros',
                                            style: TextStyle(
                                              fontFamily: 'Rufina',
                                            )),
                                        SizedBox(width: 10),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MealGenerator()),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          Colors.white, // Text color
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Meal Generator',
                                            style: TextStyle(
                                              fontFamily: 'Rufina',
                                            )),
                                        SizedBox(width: 10),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ),
                                ],
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
                      Image.asset(
                        "images/follow.png",
                        width: 15,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "images/instagram.png",
                          width: 20,
                        ),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "images/twitter.png",
                          width: 20,
                        ),
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Numbered Header
                          Stack(
                            children: [
                              Text(
                                "01",
                                style: TextStyle(
                                  fontFamily: 'Rufina',
                                  fontSize: 100,
                                  color: Colors.white.withOpacity(0.1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "images/home_line.png",
                                          width: 80,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "GET STARTED",
                                          style: TextStyle(
                                            fontFamily: 'Rufina',
                                            fontSize: 15,
                                            color: Color(0xFFFBD784),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Main Title
                                    Text(
                                      "Nutrition",
                                      style: TextStyle(
                                        fontFamily: 'Rufina',
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          // Bullet Points
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "1. Start monitoring your food intake for at least a month. Yes, it’s time to count your calories.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child:
                                    Text("• You don’t have to do this forever.",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          height: 1.5,
                                        )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    "• You’re doing this to get a rough idea of how many calories are in your food. If you don’t understand what you’re eating, you can’t make informed decisions about what to eat.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "2. Estimate your calories using the macro calculator.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    "• If you're not already super lean (<12% body fat), start things off with a cut.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    "• This will fast-track your aesthetic progress by shedding fat around your muscles, while still allowing muscle gain as a beginner.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          'images/gym.png',
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Numbered Header
                          Stack(
                            children: [
                              Text(
                                "02",
                                style: TextStyle(
                                  fontFamily: 'Rufina',
                                  fontSize: 100,
                                  color: Colors.white.withOpacity(0.1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "images/home_line.png",
                                          width: 80,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Fitness Essentials",
                                          style: TextStyle(
                                            fontFamily: 'Rufina',
                                            fontSize: 15,
                                            color: Color(0xFFFBD784),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Main Title
                                    Text(
                                      "Gym",
                                      style: TextStyle(
                                        fontFamily: 'Rufina',
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          // Bullet Points
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "If you're a beginner, start with this routine:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                    "• Consistency is key: The main goal is to get started. Forget about finding the “perfect” routine. Worrying about the ideal routine before you even start is a waste of time. Perfect is the enemy of good.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                    "• Muscle growth comes from progressive overload: This means gradually increasing the challenge on your muscles by adding weight, reps, sets, or reducing rest time. If you’re not pushing yourself harder each time, you’re not building muscle.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                    "• Track your progress: Write down your lifts, reps, weight, and sets. Recording this info will help you see progress and ensure you’re steadily overloading your muscles.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                    "• Aim for 3 gym sessions a week: 3-5 is ideal, but even one session a week is better than nothing. Just start!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                            ],
                          ),
                        ],
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
                  // Text Section
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Numbered Header
                          Stack(
                            children: [
                              Text(
                                "03",
                                style: TextStyle(
                                  fontFamily: 'Rufina',
                                  fontSize: 100,
                                  color: Colors.white.withOpacity(0.1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "images/home_line.png",
                                          width: 80,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "The basics are the key",
                                          style: TextStyle(
                                            fontFamily: 'Rufina',
                                            fontSize: 15,
                                            color: Color(0xFFFBD784),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Main Title
                                    Text(
                                      "Mindset & Discipline",
                                      style: TextStyle(
                                        fontFamily: 'Rufina',
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          // Bullet Points
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Reframe how you view your health and fitness:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    "• There will come a time—probably sooner than you'd expect—when you won't be able to do squats, deadlifts, or push-ups. So, make the most of the years where you can. Lifting isn't a chore, it's a gift.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                    "• Master the art of showing up. To build a strong, healthy, and athletic body, you’ve got to go even when you don’t feel like it. Go when it’s raining. Go on your birthday. Just show up.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 20),
                                child: Text(
                                    "• Your new identity is: “I am a healthy and athletic person.” Just like someone quitting smoking says, “No thanks, I’m trying to quit,” a non-smoker simply says, “I don’t smoke.” When offered seconds or tempted to skip the gym, ask yourself,\"What would a healthy person do?\"",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          'images/mind.png',
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
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: About Section
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MNTN",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Get out there & discover your next\nslope, mountain & destination!",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Copyright © 2023 MNTN, Inc. Terms & Privacy",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Middle Column: Blog Section
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "More on The Blog",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 18,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "About MNTN",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Contributors & Writers",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Write For Us",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Contact Us",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right Column: Company Section
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "More on MNTN",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 18,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "The Team",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Jobs",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Press",
                              style: TextStyle(
                                fontFamily: 'Rufina',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
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
    );
  }
}
