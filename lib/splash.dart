import 'constant.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: kPrimaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                """
Full
comfort
in your home""",
                style: TextStyle(
                    fontSize: 30.0, height: 1.7, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 0.0,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                """
The main idea behind science and technology
 is to make lives simpler and easier""",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Image.asset(
              "assets/images/ac2.png",
              cacheHeight: 300,
              scale: 2,
            ),
            SizedBox(height: 180.0),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => (Home()),
                  ));
                },
                label: Icon(Icons.arrow_forward),
                icon: Text("Get Started"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.cyan.shade300),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
