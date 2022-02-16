import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  List<DataRow> _rowList = [];

  void _addRow(String product, int quantity, int index) {
    // Built in Flutter Method.
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below.
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(Text(product)),
        DataCell(Text(quantity.toString())),
        DataCell(Text(quantity.toString())),
        // DataCell(MaterialButton(onPressed: () {}, child: Text("Delete"))),
      ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Platform.isAndroid ? 100 : null,
        backgroundColor: Colors.indigo.shade700,
        centerTitle: false,
        title: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: "Tap here to focus",
                  filled: true,
                  fillColor: Colors.indigo.shade300,
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
          ],
        ),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              setState(() {
                _addRow(this._scannedItem, 1, 1);
              });
            },
            child: Text("Submit".toUpperCase()),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columnSpacing: MediaQuery.of(context).size.width * 0.2,
                  columns: [
                    DataColumn(
                      label: Text(
                        "Product",
                        style: (TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Quantity",
                        style: (TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Action",
                        style: (TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                  rows: _rowList)
              //   Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10.0),
              //   color: index % 2 == 0
              //       ? Colors.white70
              //       : Colors.blueGrey.shade50,
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           _scanData[index]._getValue(),
              //           style: (TextStyle(
              //               fontSize: 15.0, fontWeight: FontWeight.bold)),
              //         ),
              //         Text(
              //           _scanData[index]._getQuantitiy().toString(),
              //           style: (TextStyle(
              //               fontSize: 15.0)),
              //         ),
              //         MaterialButton(
              //           onPressed: () {},
              //           textColor: Colors.red,
              //           child: Text(
              //             "DELETE",
              //             style: (TextStyle(fontSize: 12.0)),
              //           ),
              //         ),
              //       ]),
              // );
              ),
        ],
      ),
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
        child: CircleAvatar(child: Icon(Icons.send), backgroundColor: Colors
            .transparent, foregroundColor: Colors.white, ),
      ),
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

  String _getValue() {
    return this.value;
  }

  int? _getQuantitiy() {
    return this._quantity;
  }
}
