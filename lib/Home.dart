import 'package:flutter/material.dart';
import 'package:wear_os3/Connecting.dart';
import 'package:wear_os3/Notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _message = 'Press a button to see a message';

  // Functions to handle button presses
  void _button1Pressed() {
    setState(() {
      _message = 'Button 1 Pressed';
    });
  }

  void _button2Pressed() {
    setState(() {
      _message = 'Button 2 Pressed';
    });
  }

  void _button3Pressed() {
    setState(() {
      _message = 'Button 3 Pressed';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Adjust text size based on screen width (smaller for smaller screens)
    double textSize = screenWidth < 400 ? 14 : 18;

    // Adjust button size based on screen width
    double buttonWidth = screenWidth * 0.6; // 60% of the screen width
    double buttonHeight = 40.0; // Set a fixed height for buttons

    // Adjust vertical spacing based on screen height
    double verticalSpacing = screenHeight * 0.02; // 2% of the screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(
              screenWidth * 0.05), // Adjust padding based on screen width
          child: Scrollbar(
            // Adding Scrollbar
            child: SingleChildScrollView(
              // Wrap content in SingleChildScrollView
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Connecting()),
                      ); // Navigate to Next Page on button click
                    },
                    icon: const Icon(Icons.wifi), // Wifi icon
                    label: Text('Connect',
                        style: TextStyle(fontSize: textSize * textScaleFactor)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(buttonWidth, 30),
                    ),
                  ),
                  const SizedBox(height: 1),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notifications()),
                      );
                    },
                    icon: const Icon(Icons.notifications), // Notifications icon
                    label: Text('Notifications',
                        style: TextStyle(fontSize: textSize * textScaleFactor)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(buttonWidth, 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
