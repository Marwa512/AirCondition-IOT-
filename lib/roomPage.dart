import 'dart:convert';

import 'faceDetection1.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'BluetoothApp.dart';
import 'HomeScreen.dart';
import 'enableBluetooth.dart';

import 'constant.dart';

class room extends StatefulWidget {
  @override
  State<room> createState() => _roomState();
}

// ignore: camel_case_types
class _roomState extends State<room> {
  @override
  Widget build(BuildContext context) {
    void submit() {
      Navigator.of(context).pop();
    }

    Future openDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("People Number"),
            content: TextFormField(
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) {
                print(value);
                BluetoothApp.sendToArd(value.toString());
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 3.0),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'People number',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  submit();
                },
                child: Text("submit"),
              )
            ],
          ),
        );

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
          " AC",
          style: TextStyle(fontSize: 20, color: white1),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 38),
        child: Container(
          height: 731,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  NetworkImage("https://pngimg.com/uploads/snow/snow_PNG5.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* SizedBox(
                  width: 5,
                ), */
                  TextButton(
                    child: Text(
                      "+",
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: Size(100, 40),
                      textStyle: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => enable()),
                ); */
                    },
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  TextButton(
                    child: Text(
                      "-",
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: Size(100, 40),
                      textStyle: TextStyle(
                        fontSize: 40,
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
              SizedBox(
                height: 50,
              ),
              Text(
                "OR",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                child: Text(
                  "Face Detection",
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size(140, 40),
                  textStyle: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FaceDetectionPage(),
                  ));
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                child: Text(
                  "Enter Number ",
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size(140, 40),
                  textStyle: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  openDialog();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
