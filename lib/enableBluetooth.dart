import 'package:flutter/material.dart';
import 'HomeScreen.dart';

import 'constant.dart';
import 'roomPage.dart';

class enable extends StatefulWidget {
  @override
  State<enable> createState() => _enableState();
}

class _enableState extends State<enable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white12,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            color: Colors.black,
          ),
          title: Text(
            "Enable Bluetooth",
            style: TextStyle(fontSize: 20, color: white1),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.toggle_on_sharp),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => room()));
              },
              color: Colors.black,
              iconSize: 40,
            ),
          ]),
      body: Container(
        padding: EdgeInsets.only(bottom: 38),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 125,
                ),
                TextButton(
                  child: Text(
                    "Connect",
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minimumSize: Size(140, 40),
                    textStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => enable()),
                ); */
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
