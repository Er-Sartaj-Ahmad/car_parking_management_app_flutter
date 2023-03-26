import 'dart:convert';
import 'package:car_parking_system/models/floor.dart';
import 'package:car_parking_system/models/vehicleType.dart';
import 'package:car_parking_system/services/vehicleTypeModel.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddFloorsAndSlots extends StatefulWidget {
  final String floorname;
  final int slots, id;

  AddFloorsAndSlots(
      {required this.floorname, required this.slots, required this.id});

  @override
  State<AddFloorsAndSlots> createState() => _AddFloorsAndSlotsState(
      floorname: this.floorname, slots: this.slots, id: this.id);
}

class _AddFloorsAndSlotsState extends State<AddFloorsAndSlots> {
  final String floorname;
  final int slots, id;

  _AddFloorsAndSlotsState(
      {required this.floorname, required this.slots, required this.id});

  TextEditingController _floorNameController = TextEditingController();
  TextEditingController _slotController = TextEditingController();
  String? _floorNameInputError;
  String? _slotInputError;
  List<VehicleType>? _vehicleTypes = [];
  List<VehicleType>? _selectedVehicleTypes = [];
  double? _width;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    for (var i in _selectedVehicleTypes!) {
      _vehicleTypes!.remove(i);
    }
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    MyTextField(
                      width: _width! * 0.9,
                      controller: _floorNameController,
                      labelText: 'Floor Name',
                      hintText: 'Enter Floor Name',
                      errorText: _floorNameInputError,
                      onChanged: (v) {
                        if (v != null) {
                          _floorNameInputError = null;
                          setState(() {});
                        }
                      },
                    ),
                    MyTextField(
                      width: _width! * 0.9,
                      controller: _slotController,
                      labelText: 'Number of Slots',
                      hintText: 'Enter Number of Slots',
                      errorText: _slotInputError,
                      onChanged: (v) {
                        if (v != null) {
                          _slotInputError = null;
                          setState(() {});
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        width: _width! * 0.9,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: ExpansionTile(
                          title: Text("Supportive Vehilce Types"),
                          children: [
                            for (var i in _selectedVehicleTypes!)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: _width! * 0.05,
                                    right: _width! * 0.05,
                                    top: 10,
                                    bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: ClipOval(
                                        child: Text(
                                      "${i.title![0]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.fontSize,
                                      ),
                                    )),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _vehicleTypes!.add(i);
                                        _selectedVehicleTypes!.remove(i);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  title: Text(i.title!),
                                  // subtitle: Text("1/11/2022"),
                                  focusColor: Colors.grey,
                                ),
                              ),
                            for (var i in _vehicleTypes!)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: _width! * 0.05,
                                    right: _width! * 0.05,
                                    top: 10,
                                    bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: ClipOval(
                                        child: Text(
                                      "${i.title![0]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.fontSize,
                                      ),
                                    )),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _selectedVehicleTypes!.add(i);
                                        _vehicleTypes!.remove(i);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      )),
                                  title: Text(i.title!),
                                  // subtitle: Text("1/11/2022"),
                                  focusColor: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    MyButton(
                      onPressed: () async {
                        if (_floorNameController.text.isNotEmpty &&
                            _slotController.text.isNotEmpty &&
                            _selectedVehicleTypes!.isNotEmpty) {
                          if (this.id == 0) {
                            await _addfloor();
                            await _addslots();
                            await _addfloorSupportVehileType();
                            _confirmatoinDialog();
                            _slotController.clear();
                            _floorNameController.clear();
                            _vehicleTypes!.addAll(_selectedVehicleTypes!);
                            _selectedVehicleTypes = [];
                            setState(() {});
                            return;
                          } else {
                            // await _updatefloor();
                            // await _updateslots();
                            _slotController.clear();
                            _floorNameController.clear();
                            _vehicleTypes!.addAll(_selectedVehicleTypes!);
                            _selectedVehicleTypes = [];
                            setState(() {});
                            return;
                          }
                        }
                        if (_floorNameController.text.isEmpty) {
                          _floorNameInputError = "Required";
                        }
                        if (_slotController.text.isEmpty) {
                          _slotInputError = "Required";
                        }
                        if (_floorNameController.text.isNotEmpty &&
                            _slotController.text.isNotEmpty &&
                            _selectedVehicleTypes!.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Required",
                                      style: TextStyle(color: Colors.red)),
                                  content: Text("Add at least one Vehile Type"),
                                  // content: Text("Dialog Content"),
                                );
                              });
                        }
                        setState(() {});
                      },
                      name: "Save",
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _confirmatoinDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Oparation Successful',
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Close',
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
              elevation: 20.0,
            ));
  }

  @override
  initState() {
    if (this.id != 0) {
      _floorNameController.text = floorname;
      _slotController.text = slots.toString();
    }
    _loadData();
    super.initState();
  }

  _loadData() async {
    await _getVehicleTypes();
    // if (this.id != 0) {
    //   await _getSelectedVehicleTypes(this.id);
    // }
    _loading = false;
    setState(() {});
  }

  _getVehicleTypes() async {
    _vehicleTypes!.clear();
    List list = await VehicleType().getVehicleTypes();
    for (VehicleTypeModel i in list) {
      VehicleType vehicleType = VehicleType();
      vehicleType.setValues(i);
      _vehicleTypes!.add(vehicleType);
    }
  }

  _addfloor() async {
    Floor floor = Floor();
    floor.name = _floorNameController.text;
    await floor.addfloor();
  }

  _addslots() async {
    Floor floor = Floor();
    floor.name = _floorNameController.text;
    floor.totalSlots = int.parse(_slotController.text);
    await floor.addslots();
  }

  _addfloorSupportVehileType() async {
    Floor floor = Floor();
    floor.name = _floorNameController.text;
    floor.vehicleTypes = _selectedVehicleTypes!;
    await floor.addSupportiveVehileType();
  }
}
