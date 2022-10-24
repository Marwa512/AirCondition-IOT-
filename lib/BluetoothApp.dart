// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unused_field
// ignore_for_file: prefer_const_constructors, file_names, unnecessary_new
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'roomPage.dart';
import 'HomeScreen.dart';
import 'constant.dart';

class BluetoothApp extends StatefulWidget {
  static void sendToArd(String numOfPerson) async {
    _BluetoothAppState.connection.output.add(utf8.encode(numOfPerson + "\r\n"));
    await _BluetoothAppState.connection.output.allSent;
  }

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  static BluetoothConnection connection;
  int _deviceState;
  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection.isConnected;
  List<BluetoothDevice> _deviceList = [];
  BluetoothDevice _device;
  static bool _connected = false;
  bool _isButtonUnavailabe = false;
  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };
  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    _deviceState = 0;
    enableBluetooth();
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailabe = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Future<void> enableBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _deviceList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            Switch(
                activeColor: kPrimaryColor,
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  future() async {
                    if (value) {
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else {
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }
                    await getPairedDevices();
                    _isButtonUnavailabe = false;
                    if (_connected) {
                      _disconnect();
                    }
                  }

                  future().then((_) {
                    setState(() {});
                  });
                })
          ]),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: _isButtonUnavailabe &&
                _bluetoothState == BluetoothState.STATE_ON,
            child: LinearProgressIndicator(
              backgroundColor: Colors.yellow,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Paired Devices",
                      style: TextStyle(
                          fontSize: 20,
                          color: kTextColor,
                          fontFamily: 'RussoOne'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: DropdownButton(
                              isExpanded: true,
                              items: _getDeviceItems(),
                              onChanged: (value) =>
                                  setState(() => _device = value),
                              value: _deviceList.isNotEmpty ? _device : null,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: ElevatedButton(
                                onPressed: _isButtonUnavailabe
                                    ? null
                                    : _connected
                                        ? _disconnect
                                        : _connect,
                                child: Text(
                                  _connected ? 'Disconnect' : 'Connect',
                                  style: TextStyle(color: kTextColor),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kPrimaryColor),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: new BorderSide(
                          color: _deviceState == 0
                              ? colors['neutralBorderColor']
                              : _deviceState == 1
                                  ? colors['onBorderColor']
                                  : colors['offBorderColor'],
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      elevation: _deviceState == 0 ? 4 : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Device 1",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: _deviceState == 0
                                      ? colors['neutralBorderColor']
                                      : _deviceState == 1
                                          ? colors['onBorderColor']
                                          : colors['offBorderColor'],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  _connected ? _sendOnMessageToBluetooth : null,
                              child: Text("ON"),
                            ),
                            TextButton(
                              onPressed: _connected
                                  ? _sendOffMessageToBluetooth
                                  : null,
                              child: Text("OFF"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                color: kPrimaryColor,
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If you cannot find the device, Please go to the bluetooth setting and pair it ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        elevation: 2,
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () {
                        FlutterBluetoothSerial.instance.openSettings();
                      },
                      icon: Icon(
                        Icons.bluetooth,
                        color: kTextColor,
                      ),
                      label: Text(
                        "Settings",
                        style: TextStyle(
                          fontFamily: 'RussoOne',
                          color: kTextColor,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => room()),
                          );
                        },
                        style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor: kPrimaryColor,
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: 'RussoOne',
                            color: kTextColor,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_deviceList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text("None"),
      ));
    } else {
      _deviceList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() async {
    setState(() {
      _isButtonUnavailabe = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print("Connected");
          connection = _connection;
          setState(() {
            _connected = true;
          });
          connection.input.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnected locally');
            } else {
              print("Disconnected remotely");
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((onError) {
          print("cannot connect");
          print(onError);
        });
        show('Device connected');
        setState(() {
          _isButtonUnavailabe = false;
        });
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailabe = true;
      _deviceState = 0;
    });
  }

  void _sendOnMessageToBluetooth() async {
    connection.output.add(utf8.encode("1" + "\r\n"));
    await connection.output.allSent;
    show('Device Turned On');
    setState(() {
      _deviceState = 1;
    });
  }

  void _sendOffMessageToBluetooth() async {
    connection.output.add(utf8.encode("0" + "\r\n"));
    await connection.output.allSent;
    show("Device Turned Off");
    setState(() {
      _deviceState = -1;
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
