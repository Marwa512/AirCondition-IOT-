import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherFactory ws;
  List<Weather> _data = [];

  AppState _state = AppState.NOT_DOWNLOADED;
  String _weatherIcon;
  String desc;
  Temperature _temperature;
  double lat, lon;
  double celsius;
  double temp;
  String cityName = 'tanta';
  String icon;
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
      _temperature = weather.temperature;
      celsius = weather.temperature.celsius;
      (celsius).toStringAsPrecision(2);

      _weatherIcon = weather.weatherIcon;
      // _weatherIcon!.codeUnits;
      icon = "$_weatherIcon";
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget contentFinishedDownload() {
    return Center(
      child: Text(
        (celsius).toStringAsPrecision(4),
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(children: [
        Text(
          'Fetching Weather...',
          style: TextStyle(fontSize: 20),
        ),
        Container(
            margin: EdgeInsets.only(top: 50),
            child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: queryWeather,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather Example App'),
        ),
        body: Column(
          children: <Widget>[
            // _coordinateInputs(),
            _buttons(),
            Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            Expanded(child: _resultView())
          ],
        ),
      ),
    );
  }
}
