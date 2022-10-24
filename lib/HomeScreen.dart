import 'dart:ui';
import 'roomPage.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'BluetoothApp.dart';
import 'constant.dart';
import 'weather.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherFactory ws;
  AppState _state = AppState.NOT_DOWNLOADED;
  String _weatherIcon;
  String desc = " ";
  String desc1 = " ";
  Temperature _temperature;
  double celsius = 0.0;

  String cityName = 'tanta';
  DateTime _date;
  int day;
  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByCityName(cityName);

    setState(() {
      desc = weather.weatherDescription;
      _weatherIcon = weather.weatherIcon;
      desc1 = desc[0].toUpperCase() + desc.substring(1);
      _temperature = weather.temperature;
      celsius = weather.temperature.celsius;

      //celsius!.toInt();
      _date = weather.date;
      day = _date.day;
      _date.hour;

      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget weatherWidget() {
    return Center(
      child: Container(
        child: Column(
          children: [
            // Text("$_date"),
            Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Image.network(
                    "https://openweathermap.org/img/wn/$_weatherIcon@2x.png",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    (celsius).toStringAsPrecision(4) + " °C",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "$desc1",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white12,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.location_on,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              color: Colors.black,
              iconSize: 30,
            ),
            Text(
              "Home",
              style: TextStyle(fontSize: 22, color: white1),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              queryWeather();
            },
            iconSize: 35,
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome !",
                    style: TextStyle(
                      fontSize: 26,
                      color: white1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Opacity(
                    opacity: .8,
                    child: weatherWidget(),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Rooms ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 26,
                        color: white1,
                        fontWeight: FontWeight.w500),
                  ),
                  SafeArea(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 180.0,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return buildRoom();
                                },
                              )))),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 100),
                      TextButton(
                        child: Text(
                          "Select",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BluetoothApp()),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildRoom() {
    return Card(
      color: Colors.cyan.shade100,
      semanticContainer: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(children: [
              SizedBox(
                width: 30,
              ),
              /* Image.network(
                "https://th.bing.com/th/id/R.368d89de0848bd754fe18eab70e1549e?rik=3Bzyv8lwvE9kGg&pid=ImgRaw&r=0",
                scale: 15,
                alignment: Alignment.topRight,
              ), */
              Image.asset(
                "assets/images/ac3.png",
                scale: 15,
                alignment: Alignment.topRight,
              ),
            ]),
            SizedBox(
              height: 5,
            ),
            Text('Bedroom ', style: new TextStyle(color: Colors.black)),
            Text('AC',
                style: new TextStyle(color: Colors.black, fontSize: 24.0)),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => room()),
                  );
                },
                child: Text('on-off',
                    style: new TextStyle(color: Colors.black, fontSize: 18.0))),
          ],
        ),
      ),
    );
    // ignore: dead_code
  }
}
