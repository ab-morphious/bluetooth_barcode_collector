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
  }

  List<DataRow> _rowList = [];
  static var itemIndex = 0;
  void _addRow(String product, int quantity, int id) {
    // Built in Flutter Method.
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below.
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(Text(product)),
        DataCell(Text(quantity.toString())),
        DataCell(IconButton(
          onPressed: () {
            setState(() {
              _rowList.removeAt(id);
              print(id);
              id = id - 1;
            });
          },
          icon: Icon(
            Icons.delete,
            size: 22,
            color: Colors.red.shade300,
          ),
        )),
        // DataCell(MaterialButton(onPressed: () {}, child: Text("Delete"))),
      ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.indigo.shade700,
        centerTitle: false,
        title: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  hintText: "Tap here",
                  filled: true,
                  fillColor: Colors.indigo.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )),
              onChanged: (val) {
                Future.delayed(const Duration(milliseconds: 2000), () {
                  // Here you can write your code
                  _displayTextInputDialog(context);
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            color: Colors.indigo.shade500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      _clearScanData();
                    });
                  },
                  icon: Icon(
                    Icons.cleaning_services_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Clear".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      _undoScanning();
                    });
                  },
                  icon: Icon(
                    Icons.undo,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Undo".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FlatButton.icon(
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      _addRow(this._scannedItem, 1, itemIndex);
                      itemIndex = _rowList.length;
                    });
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Submit".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                    rows: _rowList),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isScaning ? Colors.red : Colors.blue,
        onPressed: () {},
        tooltip: 'Send',
        child: CircleAvatar(
          child: Icon(Icons.send),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _clearScanData() {
    setState(() {
      _rowList.clear();
    });
  }

  void _undoScanning() {
    setState(() {
      if (_rowList.length != 0) {
        _rowList.removeLast();
      }
      ;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {

              },
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),

          );
        });
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
