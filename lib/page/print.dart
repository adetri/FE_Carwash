import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/page/monitoring_page.dart';

import '../inc/method.dart';

class ThermalPrint extends StatefulWidget {
  const ThermalPrint({super.key});

  @override
  State<ThermalPrint> createState() => _ThermalPrintState();
}

class _ThermalPrintState extends State<ThermalPrint> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  dynamic items = [];
  int? selected_tile;
  BluetoothDevice? _device;

  bool _connected = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();

    // initPlatformState();
  }

  Future<void> initPlatformState() async {
    // TODO here add a permission request using permission_handler
    // if permission is not granted, kzaki's thermal print plugin will ask for location permission
    // which will invariably crash the app even if user agrees so we'd better ask it upfront

    // var statusLocation = Permission.location;
    // if (await statusLocation.isGranted != true) {
    //   await Permission.location.request();
    // }
    // if (await statusLocation.isGranted) {
    // ...
    // } else {
    // showDialogSayingThatThisPermissionIsRequired());
    // }

    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
      test_method();
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true || isConnected == 1) {
      setState(() {
        _connected = true;
      });
    }
  }

  void test_method() async {
    items = [];
    if (_devices.isEmpty) {
      print("devices empty");
    } else {
      _devices.forEach((device) {
        items.add({"device_name": device.name, "device": device});
      });
    }

    int? printer_cek = await printerCheck();

    setState(() {
      if (printer_cek == 1) {
        _connected = true;
      } else {
        _connected == false;
      }
      print(_connected);
    });
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    } else {
      print('No device selected.');
    }
  }

  void test_print() {
    bluetooth.isConnected.then((isConnected) {
      bluetooth.printCustom("Mr Carwash", 2, 1);
      bluetooth.printCustom(
          "Jagakarsa, Kec. Jagakarsa, Kota Jakarta Selatan", 1, 1);
      bluetooth.printCustom("085157792607", 1, 1);

      bluetooth.printNewLine();
      bluetooth.printCustom("11 Nov 2024 13:04", 0, 0);

      bluetooth.printCustom("No Order : 202406051234", 0, 0);

      bluetooth.printCustom("==========================================", 0, 0);
      bluetooth.printCustom("Body Polishing (full body) with thermal", 0, 0);
      bluetooth.printLeftRight("2 x 200.000", "400.000", 0);
      bluetooth.printCustom("Body Wash (full body)", 0, 0);
      bluetooth.printLeftRight("2 x 200.000.000", "400.000.000", 0);

      bluetooth.printCustom("==========================================", 0, 0);
      bluetooth.printLeftRight("Total", "400.400.000", 0);
      bluetooth.paperCut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Monitoring()),
                  );
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.topLeft,
                  child: Image.asset('assets/back.png'),
                ),
              ),
              Container(
                child: Text(
                  'Printer Bluetooth',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left, // Apply bold font weight
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, int index) {
              return Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 20, left: 10),
                child: Column(
                  children: [
                    Card(
                        color:
                            selected_tile != index ? Colors.white : Colors.grey,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _device = items[index]['device'];
                              print(_device);
                              selected_tile = index;
                            });
                          },
                          child: ListTile(
                            title: Text(items[index]['device_name']),
                          ),
                        ))
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  onPressed: () {
                    setState(() {
                      initPlatformState();
                      selected_tile = null;
                      _device = null;
                    });
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: _connected ? Colors.red : Colors.green),
                  onPressed: _connected ? _disconnect : _connect,
                  child: Text(
                    _connected ? 'Disconnect' : 'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  onPressed: () {
                    setState(() {
                      test_print();
                      // print(BlueThermalPrinter.CONNECTED);
                    });
                  },
                  child: const Text(
                    'test print',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
