import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/vehicleTypeModel.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:car_parking_system/widgets/myDropdownSearch.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/vehicleModel.dart';

class AddMembers extends StatefulWidget {
  User user;
  bool update;
  VehicleModel vehicle;

  AddMembers(
      {required this.user, required this.update, required this.vehicle});

  @override
  State<AddMembers> createState() =>
      _AddMembersState(user: user, update: update, vehicle: vehicle);
}

class _AddMembersState extends State<AddMembers> {
  User user;
  bool update;
  VehicleModel vehicle;

  _AddMembersState(
      {required this.user, required this.update, required this.vehicle});

  String? _membershipCode;
  TextEditingController _vehicleNoController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _vehicleModelController = TextEditingController();
  String? _vehicleNoError;
  String? _vehicleNameError;
  String? _vehicleModelError;
  String? _ownerNameError;
  double? _width;
  int _vehicleTypeId = 0;
  List<VehicleTypeModel> _vehicleTypes = [];
  String _inputVehicleType = "";
  String? _vehicleTypeError;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyDropdownSearch(
                  width: _width! * 0.9,
                  showSelectedItems: false,
                  items: [for (var a in _vehicleTypes) a.title.toString()],
                  errorText: _vehicleTypeError,
                  labelText: 'Vehicle Type',
                  hintText: 'Select Vehicle Type',
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (value) async {
                    _inputVehicleType = value!;
                    _vehicleTypeError = null;
                    for (var a in _vehicleTypes) {
                      if (a.title == value) {
                        _vehicleTypeId = a.id!;
                        break;
                      }
                    }
                    setState(() {});
                  },
                  selectedItem: _inputVehicleType),
              MyTextField(
                width: _width! * 0.9,
                controller: _vehicleNoController,
                labelText: 'Vehicle Number',
                hintText: 'Enter Vehicle Number',
                errorText: _vehicleNoError,
                onChanged: (v) {
                  _vehicleNoError = null;
                  setState(() {});
                },
              ),
              MyTextField(
                width: _width! * 0.9,
                controller: _vehicleNameController,
                labelText: 'Vehicle Name',
                hintText: 'Enter Vehicle Name',
                errorText: _vehicleNameError,
                onChanged: (v) {
                  _vehicleNameError = null;
                  setState(() {});
                },
              ),
              MyTextField(
                width: _width! * 0.9,
                controller: _vehicleModelController,
                labelText: 'Vehicle Model',
                hintText: 'Enter Vehicle Model',
                errorText: _vehicleModelError,
                onChanged: (v) {
                  _vehicleModelError = null;
                  setState(() {});
                },
              ),
              MyTextField(
                width: _width! * 0.9,
                controller: _ownerNameController,
                labelText: 'Vehicle Owner Name',
                hintText: 'Enter Vehicle Owner Name',
                errorText: _ownerNameError,
                onChanged: (v) {
                  _ownerNameError = null;
                  setState(() {});
                },
              ),
              MyButton(
                onPressed: () async {
                  if (_vehicleTypeId > 0 &&
                      ((_vehicleNoController.text.isNotEmpty &&
                          _vehicleNameController.text.isNotEmpty &&
                          _vehicleModelController.text.isNotEmpty &&
                          _ownerNameController.text.isNotEmpty))) {
                    bool isexist = await _getMembers();
                    if (isexist) {
                      if (update == true) {
                        await _updateMember();
                        _confirmatoinDialog();
                        return;
                      }
                      await _addMember();
                      _confirmatoinDialog();
                      _ownerNameController.clear();
                      _vehicleNameController.clear();
                      _vehicleModelController.clear();
                      _vehicleNoController.clear();
                      _inputVehicleType = "";
                      _memberShipCodeAlert();
                    } else {
                      _vehicleNoError = "Already Exit";
                    }
                    setState(() {});
                    return;
                  }
                  if (_inputVehicleType.isEmpty) _vehicleTypeError = "Required";
                  if (_vehicleNoController.text.isEmpty)
                    _vehicleNoError = "Required";
                  if (_vehicleModelController.text.isEmpty)
                    _vehicleModelError = "Required";
                  if (_vehicleNameController.text.isEmpty)
                    _vehicleNameError = "Required";
                  if (_ownerNameController.text.isEmpty)
                    _ownerNameError = "Required";
                  setState(() {});
                },
                name: update ? "Update" : "Submit",
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

  _memberShipCodeAlert() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  '${_membershipCode}',
                ),
              ),
              content: Center(
                child: Text(
                  "is your membership code",
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                TextButton(
                  child: Text(
                    'OK',
                  ),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                ),
              ],
              elevation: 20.0,
            ));
  }

  @override
  initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    await _getVehicleTypes();
    if (vehicle.membershipCode! > 0) {
      _vehicleNoController.text = vehicle.vehicleNo!;
      _vehicleNameController.text = vehicle.vehicleName!;
      _vehicleModelController.text = vehicle.vehicleModel.toString();
      _ownerNameController.text = vehicle.ownerName!;
      for (var a in _vehicleTypes)
        if (a.id == vehicle.vehicleTypeId) {
          _inputVehicleType = a.title!;
          _vehicleTypeId = a.id!;
        }
    }
    _loading = false;
    setState(() {});
  }

  _getMembers() async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/getVehicle.php"),
        body: {
          'vehicleNo': _vehicleNoController.text,
          'vehicleTypeId': _vehicleTypeId.toString()
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.length > 0) {
        if (update) {
          for (Map i in data) {
            if (VehicleModel.fromJson(i).membershipCode ==
                vehicle.membershipCode) return true;
          }
          return false;
        } else {
          return false;
        }
      } else
        return true;
    } else {
      return response.body.toString();
    }
  }

  _getVehicleTypes({int floorId = 0}) async {
    final response;
    if (floorId == 0)
      response = await http.get(Uri.parse(
          "http://localhost/Registration/SDA_Project/getVehicleTypes.php"));
    else
      response = await http.post(
          Uri.parse(
              "http://localhost/Registration/SDA_Project/getFlrSprtVchls.php"),
          body: {'floorId': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _vehicleTypes.clear();
      for (Map i in data) {
        // print(i);
        _vehicleTypes.add(VehicleTypeModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _addMember() async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/insertMember.php"),
        body: {
          'userId': user.id.toString(),
          'vehicleTypeId': _vehicleTypeId.toString(),
          'vehicleNo': _vehicleNoController.text,
          'vehicleName': _vehicleNameController.text,
          'vehicleModel': _vehicleModelController.text,
          'ownerName': _ownerNameController.text
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        _membershipCode = i['id'].toString();
      }
      // print(response.body);
    } else {
      print(response.body.toString());
    }
  }

  _updateMember() async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/updateMember.php"),
        body: {
          'membershipCode': vehicle.membershipCode.toString(),
          'vehicleTypeId': _vehicleTypeId.toString(),
          'userId': user.id.toString(),
          'vehicleNo': _vehicleNoController.text,
          'vehicleName': _vehicleNameController.text,
          'vehicleModel': _vehicleModelController.text,
          'ownerName': _ownerNameController.text
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (Map i in data) {
        _membershipCode = i['id'].toString();
      }
      // print(response.body);
    } else {
      print(response.body.toString());
    }
  }
}
