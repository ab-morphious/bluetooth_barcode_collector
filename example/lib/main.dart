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

  //List of scanned data
  List<_ScannedData> _scanData = [];
  String _scannedItem = "";
  int _quantity = -1;
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
                  )),
              onChanged: (val) {
                setState(() {
                  this._scannedItem = val;
                });
              },
            ),
            MaterialButton(
              onPressed: () {
                setState(() {
                  _scanData
                      .add(new _ScannedData(this._scannedItem, this._quantity));
                });
              },
              child: Text("Submit".toUpperCase()),
            )
          ],
        ),
      ),

      body: ListView.builder(
          itemCount: _scanData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                leading: Text(_scanData[index]._getValue()),
                trailing: Text(_scanData[index]._getQuantitiy().toString()));
          }),
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

class _ScannedData {
  final String value;
  final int? _quantity;

  _ScannedData(this.value, this._quantity);

  String _getValue(){
    return this.value;
  }

  int? _getQuantitiy(){
    return this._quantity;
  }
}
