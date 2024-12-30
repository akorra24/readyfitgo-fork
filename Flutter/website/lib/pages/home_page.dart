import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:website/pages/macro_calculator_page.dart';
import 'package:website/pages/meal_generator_page.dart';
import 'dart:html' as html;

class HomePage extends StatelessWidget {
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
                  onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Container(
          color: const Color(0xFF0A1D26), // Dark blue background color
          child: ListView(
            children: [
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Calculate Macros',
                  style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MacroCalculatorPage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Meal Generator',
                  style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MealGenerator()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Shop Now',
                  style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
                onTap: () {
                  html.window.open('https://readyfitgo.com/shop', '_blank');
                },
              ),
            ],
          ),
        ),
      ),
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
                      colors: [Color(0xFF0B1D26), Colors.transparent],
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      // Central Content
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.25),
                            child: Column(
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
                                        letterSpacing: 5,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Fit your budget.",
                                  style: TextStyle(
                                    fontFamily: 'Rufina',
                                    fontSize:
                                        MediaQuery.of(context).size.width < 600
                                            ? 30 // Mobile screens
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1200
                                                ? 60 // Tablet screens
                                                : 80,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Fit your lifestyle.",
                                  style: TextStyle(
                                    fontFamily: 'Rufina',
                                    fontSize:
                                        MediaQuery.of(context).size.width < 600
                                            ? 30 // Mobile screens
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1200
                                                ? 60 // Tablet screens
                                                : 80,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                LayoutBuilder(builder: (context, constraints) {
                                  if (MediaQuery.of(context).size.width < 700) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            backgroundColor: Color.fromRGBO(
                                                12,
                                                31,
                                                39,
                                                0.7), // Background color
                                            side: const BorderSide(
                                              color:
                                                  Colors.white, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // Button corner radius
                                            ),
                                            minimumSize: Size(250, 50),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Calculate Macros',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'RufinaBold',
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                              SizedBox(width: 10),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
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
                                            backgroundColor: Color.fromRGBO(
                                                12,
                                                31,
                                                39,
                                                0.7), // Background color
                                            side: const BorderSide(
                                              color:
                                                  Colors.white, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // Button corner radius
                                            ),
                                            minimumSize: Size(250, 50),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Meal Generator',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'RufinaBold',
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                              SizedBox(width: 10),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            backgroundColor: Color.fromRGBO(
                                                12,
                                                31,
                                                39,
                                                0.7), // Background color
                                            side: const BorderSide(
                                              color:
                                                  Colors.white, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // Button corner radius
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Calculate Macros',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'RufinaBold',
                                                    fontWeight: FontWeight.w800,
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
                                            backgroundColor: Color.fromRGBO(
                                                12,
                                                31,
                                                39,
                                                0.7), // Background color
                                            side: const BorderSide(
                                              color:
                                                  Colors.white, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      5), // Button corner radius
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text('Meal Generator',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'RufinaBold',
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                              SizedBox(width: 10),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                              ],
                            ),
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
                  top: MediaQuery.of(context).size.height * 0.37,
                  child: Column(
                    children: [
                      Image.asset(
                        "images/follow.png",
                        width: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            html.window.open(
                                'https://www.instagram.com/readyfitgo_cali/',
                                '_blank');
                          },
                          child: Image.asset(
                            "images/instagram.png",
                            width: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          html.window
                              .open('https://twitter.com/readyfitgo', '_blank');
                        },
                        child: Image.asset(
                          "images/twitter.png",
                          width: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Features Section
            Container(
                color: const Color(0xFF0B1D26), // Dark blue background color
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      children: [
                        // Text Section
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Numbered Header
                              Column(
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
                              // Bullet Points
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "1. Start monitoring your food intake for at least a month. Yes, it’s time to count your calories.",
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                        height: 1.5,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                        "• You don’t have to do this forever.",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                        height: 1.5,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                        "• If you're not already super lean (<12% body fat), start things off with a cut.",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                        SizedBox(width: 20),
                        // Image Section
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            child: Image.asset(
                              'images/nutrition.png',
                              width: 450,
                              height: 600,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text Section
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                top: MediaQuery.of(context).size.height * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Numbered Header
                                Column(
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
                                // Bullet Points
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "1. Start monitoring your food intake for at least a month. Yes, it’s time to count your calories.",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                          height: 1.5,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                          "• You don’t have to do this forever.",
                                          style: TextStyle(
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w600,
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
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w600,
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
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                          height: 1.5,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                          "• If you're not already super lean (<12% body fat), start things off with a cut.",
                                          style: TextStyle(
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w600,
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
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w600,
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
                                width: 450,
                                height: 600,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                })),
            // Features Section
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(
                    children: [
                      // Text Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Numbered Header
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "images/home_line.png",
                                    width: 60,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "FITNESS ESSENTIALS",
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
                          SizedBox(height: 20),
                          // Bullet Points
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "If you're a beginner, start with this routine:",
                                  style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                    "• Consistency is key: The main goal is to get started. Forget about finding the “perfect” routine. Worrying about the ideal routine before you even start is a waste of time. Perfect is the enemy of good.",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
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
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
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
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
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
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      // Image Section
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          child: Image.asset(
                            'images/gym.png',
                            width: MediaQuery.of(context).size.width,
                            height: 600,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
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
                              width: 450,
                              height: 600,
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
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Numbered Header
                              Column(
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
                                        "FITNESS ESSENTIALS",
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
                              SizedBox(height: 20),
                              // Bullet Points
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "If you're a beginner, start with this routine:",
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                        height: 1.5,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                        "• Consistency is key: The main goal is to get started. Forget about finding the “perfect” routine. Worrying about the ideal routine before you even start is a waste of time. Perfect is the enemy of good.",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                          height: 1.5,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
            // Features Section
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(
                    children: [
                      // Text Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Numbered Header
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "images/home_line.png",
                                    width: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "THE BASICS ARE THE KEY",
                                    style: TextStyle(
                                      fontFamily: 'Rufina',
                                      fontSize: 13,
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
                          SizedBox(height: 20),
                          // Bullet Points
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Reframe how you view your health and fitness:",
                                  style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    "• There will come a time—probably sooner than you'd expect—when you won't be able to do squats, deadlifts, or push-ups. So, make the most of the years where you can. Lifting isn't a chore, it's a gift.",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
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
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
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
                                      fontFamily: 'Satoshi',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.5,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      // Image Section
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          child: Image.asset(
                            'images/mind.png',
                            width: 450,
                            height: 600,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      // Text Section
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Numbered Header
                              Column(
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
                                        "THE BASICS ARE THE KEY",
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
                              SizedBox(height: 20),
                              // Bullet Points
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Reframe how you view your health and fitness:",
                                      style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                        height: 1.5,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                        "• There will come a time—probably sooner than you'd expect—when you won't be able to do squats, deadlifts, or push-ups. So, make the most of the years where you can. Lifting isn't a chore, it's a gift.",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                          height: 1.5,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Text(
                                        "• Master the art of showing up. To build a strong, healthy, and athletic body, you’ve got to go even when you don’t feel like it. Go when it’s raining. Go on your birthday. Just show up.",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                          height: 1.5,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Text(
                                        "• Your new identity is: “I am a healthy and athletic person.” Just like someone quitting smoking says, “No thanks, I’m trying to quit,” a non-smoker simply says, “I don’t smoke.” When offered seconds or tempted to skip the gym, ask yourself,\"What would a healthy person do?\"",
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          fontWeight: FontWeight.w600,
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
                              width: 450,
                              height: 600,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
            // Footer Section
            Container(
              color: const Color(0xFF0B1D26), // Dark blue background color
              padding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: MediaQuery.of(context).size.width * 0.01),
              child: Column(
                children: [
                  Text(
                    "Fresh. Convenient. Local.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width < 700
                            ? MediaQuery.of(context).size.width * 0.001
                            : MediaQuery.of(context).size.width / 4),
                    child: Text(
                      "We're passionate about making healthy living easy with fresh, ready-to-eat meals designed to fit your lifestyle. Our meals are machine-sealed with nitrogen gas to stay fresh for up to 14 days—no freezing needed. Whether you're ordering for delivery or picking up in-store, our meals are made to fuel your goals without the hassle. From personalized coaching to flexible meal plans, we’re here to support your wellness journey every step of the way.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          html.window.open(
                              'https://www.facebook.com/RFGHermosaBeach/',
                              '_blank');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "images/Facebook.png",
                                width: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          html.window.open(
                              'https://www.instagram.com/readyfitgo_cali/',
                              '_blank');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "images/Instagram_2.png",
                                width: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Instagram',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: LayoutBuilder(builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/rfg_logo.png',
                              height: 100,
                            ),
                            SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "2025 ReadyFitGo. ",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Click Here",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 16,
                                      color: Color(0xFF8AEA8A), // Green color
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        html.window.open(
                                            'https://www.linkedin.com/company/ready-fit-go-corona',
                                            '_blank');
                                      },
                                  ),
                                  TextSpan(
                                    text: " for Business Inquiries.",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    html.window.open(
                                        'https://www.linkedin.com/company/ready-fit-go-corona',
                                        '_blank');
                                  },
                                  child: Image.asset(
                                    "images/Linkedin.png",
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    html.window.open(
                                        'https://twitter.com/readyfitgo',
                                        '_blank');
                                  },
                                  child: Image.asset(
                                    "images/Twitter_2.png",
                                    width: 30,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'images/rfg_logo.png',
                              height: 100,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "2025 ReadyFitGo. ",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Click Here",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 16,
                                      color: Color(0xFF8AEA8A), // Green color
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        html.window.open(
                                            'https://www.linkedin.com/company/ready-fit-go-corona',
                                            '_blank');
                                      },
                                  ),
                                  TextSpan(
                                    text: " for Business Inquiries.",
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    html.window.open(
                                        'https://www.linkedin.com/company/ready-fit-go-corona',
                                        '_blank');
                                  },
                                  child: Image.asset(
                                    "images/Linkedin.png",
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    html.window.open(
                                        'https://twitter.com/readyfitgo',
                                        '_blank');
                                  },
                                  child: Image.asset(
                                    "images/Twitter_2.png",
                                    width: 30,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      }
                    }),
                  )
                ],
              ),
            )
            // Old Footer Section
            // Container(
            //   color: const Color(0xFF0B1D26), // Dark blue background color
            //   padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Left Column: About Section
            //           Expanded(
            //             flex: 2,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "MNTN",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 24,
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Get out there & discover your next\nslope, mountain & destination!",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 120),
            //                 Text(
            //                   "Copyright © 2023 MNTN, Inc. Terms & Privacy",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 14,
            //                     color: Colors.white.withOpacity(0.6),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           // Middle Column: Blog Section
            //           Expanded(
            //             flex: 1,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "More on The Blog",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 18,
            //                     color: Colors.amberAccent,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "About MNTN",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Contributors & Writers",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Write For Us",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Contact Us",
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Privacy Policy",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           // Right Column: Company Section
            //           Expanded(
            //             flex: 1,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "More on MNTN",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 18,
            //                     color: Colors.amberAccent,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "The Team",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Jobs",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //                 SizedBox(height: 20),
            //                 Text(
            //                   "Press",
            //                   style: TextStyle(
            //                     fontFamily: 'Rufina',
            //                     fontSize: 16,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
