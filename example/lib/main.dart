import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_elves/flutter_blue_elves.dart';
import 'package:path_provider/path_provider.dart';
import 'device_control.dart';
import 'dart:io';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  bool quantityInputShown = false;
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  List<DataRow> _rowList = [];
  static var itemIndex = 0;
  List<List<String>> _data = [];
  void _addRow(String product, int quantity, int id) {
    // Built in Flutter Method.
    
    setState(() {
      //data for csv
      _data.add([product, quantity.toString(), id.toString()]);
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below.
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(Text(product)),
        DataCell(Text(quantity.toString())),
        DataCell(IconButton(
          onPressed: () {
            setState(() {
              _rowList.removeAt(id);
              _data.removeAt(id);
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
                setState(() {
                  _scannedItem = val;
                });
                Future.delayed(const Duration(milliseconds: 2000), () {
                  // Here you can write your code
                  if (quantityInputShown == false) {
                    _displayTextInputDialog(context);
                  }
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
            color: Colors.indigo.shade900,
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
                  onPressed: () {
                    setState(() {
                      _displayTextInputDialog(context);
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Quantity".toUpperCase(),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {generateCsv();},
        tooltip: 'Send',
        label: Text('Upload'),
        icon: Icon(Icons.cloud_upload),
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
    setState(() {
      quantityInputShown = true;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter quantity'),
            actions: [
              FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      quantityInputShown = false;
                    });
                    Navigator.of(context).pop();
                  }),
              FlatButton.icon(
                label: Text(
                  'DONE',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.indigo,
                onPressed: () {
                  _addRow(this._scannedItem, 1, itemIndex);
                  itemIndex = _rowList.length;
                  setState(() {
                    quantityInputShown = false;
                  });
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              )
            ],
            content: TextField(
              onChanged: (value) {
                this._quantity = int.parse(value);
              },
              decoration: InputDecoration(hintText: "Enter quantity here"),
            ),
          );
        });
  }
  generateCsv() async {
    String csvData = ListToCsvConverter().convert(_data);
    final String directory = (await getApplicationDocumentsDirectory()).toString();
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) {
    //       return LoadCsvDataScreen(path: path);
    //     },
    //   ),
    // );
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
