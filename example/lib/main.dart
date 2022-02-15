import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'device_control.dart';
import 'dart:io';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//flutter blue
class _MyAppState extends State<MyApp> {
  List<AndroidBluetoothLack> _blueLack = [];
  IosBluetoothState _iosBlueState = IosBluetoothState.unKnown;
  List<ScanResult> _scanResultList = [];
  List<HideConnectedDevice> _hideConnectedList = [];
  final List<_ConnectedItem> _connectedList = [];
  bool _isScaning = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 5000),
        Platform.isAndroid ? androidGetBlueLack : iosGetBlueState);
    getHideConnectedDevice();
  }

  void iosGetBlueState(timer) {
    FlutterBlueElves.instance.iosCheckBluetoothState().then((value) {
      setState(() {
        _iosBlueState = value;
      });
    });
  }

  void androidGetBlueLack(timer) {
    FlutterBlueElves.instance.androidCheckBlueLackWhat().then((values) {
      setState(() {
        _blueLack = values;
      });
    });
  }

  void getHideConnectedDevice() {
    FlutterBlueElves.instance.getHideConnectedDevices().then((values) {
      setState(() {
        _hideConnectedList = values;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Platform.isAndroid ? 160 : null,
        centerTitle: false,
        title: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Tap here to focus",
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )
              ),
              onChanged: (val){
                final snackBar = SnackBar(
                  content: Text('$val', style: TextStyle(color: Colors.white),),
                  backgroundColor: Colors.green,
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },

            ),
          ],
        ),
      ),

      body:
       Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isScaning ? Colors.red : Colors.blue,
        onPressed: () {
          getHideConnectedDevice();
          if ((Platform.isAndroid && _blueLack.isEmpty) ||
              (Platform.isIOS &&
                  _iosBlueState == IosBluetoothState.poweredOn)) {
            if (_isScaning) {
              FlutterBlueElves.instance.stopScan();
            } else {
              _scanResultList = [];
              setState(() {
                _isScaning = true;
              });
              FlutterBlueElves.instance.startScan(5000).listen((event) {
                setState(() {
                  _scanResultList.insert(0, event);
                });
              }).onDone(() {
                setState(() {
                  _isScaning = false;
                });
              });
            }
          }
        },
        tooltip: 'scan',
        child: Icon(_isScaning ? Icons.stop : Icons.find_replace),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _ConnectedItem {
  final Device _device;
  final String? _macAddress;
  final String? _name;

  _ConnectedItem(this._device, this._macAddress, this._name);
}
