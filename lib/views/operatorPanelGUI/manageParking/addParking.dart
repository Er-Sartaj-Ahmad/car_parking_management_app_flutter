import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/parkingModel.dart';
import 'package:car_parking_system/services/vehicleModel.dart';
import 'package:car_parking_system/services/vehicleTypeModel.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:car_parking_system/widgets/myDropdownSearch.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../services/floorModel.dart';
import '../../../services/slotModel.dart';

class AddParking extends StatefulWidget {
  User user;
  int floorId;
  int slotId;
  bool fromSlot;

  AddParking(
      {required this.user,
      required this.fromSlot,
      required this.floorId,
      required this.slotId});

  @override
  State<AddParking> createState() => _AddParkingState(
      user: user,
      fromSlot: fromSlot,
      floorId: floorId,
      slotId: slotId);
}

class _AddParkingState extends State<AddParking> {
  User user;
  bool fromSlot;
  int floorId;
  int slotId;

  _AddParkingState(
      {required this.user,
      required this.fromSlot,
      required this.floorId,
      required this.slotId});

  TextEditingController _vehicleNoController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _vehicleModelController = TextEditingController();
  TextEditingController _membershipCodeController = TextEditingController();
  String? _vehicleNoError;
  String? _vehicleNameError;
  String? _vehicleModelError;
  String? _membershipCodeError;
  String? _ownerNameError;
  double? _height;
  int? _vehicleTypeId;
  List<VehicleTypeModel> _vehicleTypes = [];
  List<FloorModel> _floors = [];
  List<SlotModel> _slots = [];
  List<ParkingModel> _parkings = [];
  String _inputVehicleType = "";
  String _inputfloor = "";
  String _inputslot = "";
  String _inputMembershipStatus = "No";
  String? _vehicleTypeError;
  String? _flootError;
  String? _slotError;
  bool _loading = true;
  bool _membership = false;
  ParkingModel _invoiceDetails = ParkingModel();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              fromSlot
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyDropdownSearch(
                            showSelectedItems: false,
                            items: [
                              for (var a in _vehicleTypes) a.title.toString()
                            ],
                            width: _height! * 0.4,
                            labelText: 'Vehicle Type',
                            hintText: 'Select Vehicle Type',
                            onChanged: (value) async {
                              _inputVehicleType = value!;
                              _vehicleTypeError = null;
                              for (var a in _vehicleTypes) {
                                if (a.title == value) {
                                  _vehicleTypeId = a.id!;
                                  break;
                                }
                              }
                              await _getFloors(_vehicleTypeId!);
                              _inputfloor = "";
                              _inputslot = "";
                              setState(() {});
                            },
                            selectedItem: _inputVehicleType,
                            errorText: _vehicleTypeError),
                        MyDropdownSearch(
                            width: _height! * 0.4,
                            errorText: null,
                            items: ["Yes", "No"],
                            labelText: 'Membership Status',
                            hintText: 'Select Membership Status',
                            onChanged: (value) {
                              _inputMembershipStatus = value!;
                              _vehicleNoController.clear();
                              _vehicleNameController.clear();
                              _vehicleModelController.clear();
                              _ownerNameController.clear();
                              _membershipCodeController.clear();
                              setState(() {});
                            },
                            selectedItem: "No"),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyDropdownSearch(
                                width: _height! * 0.4,
                                showSelectedItems: false,
                                items: [
                                  for (var a in _vehicleTypes)
                                    a.title.toString()
                                ],
                                errorText: _vehicleTypeError,
                                labelText: 'Vehicle Type',
                                hintText: 'Select Vehicle Type',
                                onChanged: (value) async {
                                  _inputfloor = "";
                                  _inputslot = "";
                                  _inputVehicleType = value!;
                                  _vehicleTypeError = null;
                                  for (var a in _vehicleTypes) {
                                    if (a.title == value) {
                                      _vehicleTypeId = a.id!;
                                      break;
                                    }
                                  }
                                  await _getFloors(_vehicleTypeId!);
                                  setState(() {});
                                },
                                selectedItem: _inputVehicleType),
                            MyDropdownSearch(
                                width: _height! * 0.4,
                                showSelectedItems: false,
                                items: [
                                  for (var a in _floors) a.name.toString()
                                ],
                                errorText: _flootError,
                                labelText: 'Floor',
                                hintText: 'Select Floor',
                                onChanged: (value) async {
                                  _inputslot = "";
                                  _inputfloor = value!;
                                  _flootError = null;
                                  for (var a in _floors) {
                                    if (a.name == value) {
                                      floorId = a.id!;
                                      break;
                                    }
                                  }
                                  await _getSlots(floorId);
                                  setState(() {});
                                },
                                selectedItem: _inputfloor),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyDropdownSearch(
                                width: _height! * 0.4,
                                showSelectedItems: false,
                                items: [
                                  for (var a in _slots)
                                    if (a.free == 1)
                                      (_slots.indexOf(a) + 1).toString()
                                ],
                                errorText: _slotError,
                                labelText: 'Slot',
                                hintText: 'Select Slot',
                                onChanged: (value) {
                                  _inputslot = value!;
                                  _slotError = null;
                                  for (var a in _slots) {
                                    if ((_slots.indexOf(a) + 1).toString() ==
                                        value) {
                                      slotId = a.id!;
                                      break;
                                    }
                                  }
                                },
                                selectedItem: _inputslot),
                            MyDropdownSearch(
                                width: _height! * 0.4,
                                items: ["Yes", "No"],
                                errorText: null,
                                labelText: 'Membership Status',
                                hintText: 'Select Membership Status',
                                onChanged: (value) {
                                  _inputMembershipStatus = value!;
                                  _vehicleNoController.clear();
                                  _vehicleNameController.clear();
                                  _vehicleModelController.clear();
                                  _ownerNameController.clear();
                                  _membershipCodeController.clear();
                                  setState(() {});
                                },
                                selectedItem: "No"),
                          ],
                        )
                      ],
                    ),
              _inputMembershipStatus == "Yes"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyTextField(
                          width: _height! * 0.4,
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
                          width: _height! * 0.4,
                          controller: _membershipCodeController,
                          labelText: 'Membership Code',
                          hintText: 'Enter Membership Code',
                          errorText: _membershipCodeError,
                          onChanged: (v) {
                            _membershipCodeError = null;
                            setState(() {});
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyTextField(
                              width: _height! * 0.4,
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
                              width: _height! * 0.4,
                              controller: _vehicleNameController,
                              labelText: 'Vehicle Name',
                              hintText: 'Enter Vehicle Name',
                              errorText: _vehicleNameError,
                              onChanged: (v) {
                                _vehicleNameError = null;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyTextField(
                              width: _height! * 0.4,
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
                              width: _height! * 0.4,
                              controller: _ownerNameController,
                              labelText: 'Vehicle Owner Name',
                              hintText: 'Enter Vehicle Owner Name',
                              errorText: _ownerNameError,
                              onChanged: (v) {
                                _ownerNameError = null;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
              MyButton(
                onPressed: () async {
                  if ((floorId > 0 && (fromSlot || _inputfloor.isNotEmpty)) &&
                      (slotId > 0 && (fromSlot || _inputslot.isNotEmpty)) &&
                      _vehicleTypeId! > 0 &&
                      ((_vehicleNoController.text.isNotEmpty &&
                              _vehicleNameController.text.isNotEmpty &&
                              _vehicleModelController.text.isNotEmpty &&
                              _ownerNameController.text.isNotEmpty) ||
                          (_vehicleNoController.text.isNotEmpty &&
                              _membershipCodeController.text.isNotEmpty))) {
                    await _getAllParkings();
                    for (var a in _parkings) {
                      if (a.vehicleNo.toString() ==
                              _vehicleNoController.text.toString() &&
                          a.vehicleTypeId == _vehicleTypeId) {
                        _vehicleNoError = "Already Exist";
                        _membershipCodeError = "Already Exist";
                        setState(() {});
                        return;
                      }
                    }
                    if (_inputMembershipStatus == "No") {
                      await _addParking();
                    } else {
                      await _checkMembership();
                      if (_membership == true) {
                        await _addParking();
                      } else {
                        _vehicleNoError = "Invalid";
                        _membershipCodeError = "Invalid";
                        setState(() {});
                        return;
                      }
                    }
                    fromSlot = false;
                    await _loadData();
                    await _getParking();
                    _invoiceAlert();
                    _slotError = null;
                    _flootError = null;
                    _membershipCodeError = null;
                    _vehicleNoError = null;
                    _ownerNameError = null;
                    fromSlot = false;
                    _vehicleNoController.clear();
                    _vehicleNameController.clear();
                    _vehicleModelController.clear();
                    _ownerNameController.clear();
                    _membershipCodeController.clear();
                    _inputVehicleType = "";
                    _inputfloor = "";
                    _inputslot = "";
                    _floors.clear();
                    _slots.clear();
                    setState(() {});
                    return;
                  }
                  if (_inputVehicleType.isEmpty) _vehicleTypeError = "Required";
                  if (_inputslot.isEmpty) _slotError = "Required";
                  if (_inputfloor.isEmpty) _flootError = "Required";
                  if (_vehicleNoController.text.isEmpty)
                    _vehicleNoError = "Required";
                  if (_vehicleNameController.text.isEmpty)
                    _vehicleNameError = "Required";
                  if (_vehicleModelController.text.isEmpty)
                    _vehicleModelError = "Required";
                  if (_membershipCodeController.text.isEmpty)
                    _membershipCodeError = "Required";
                  if (_ownerNameController.text.isEmpty)
                    _ownerNameError = "Required";
                  setState(() {});
                },
                name: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }

  _invoiceAlert() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(child: Text("Invoice")),
              content: Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Owner Name',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Operator Name',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Vehicle Name',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Vehicle No',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Vehicle Model',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Vehicle Type',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Charges',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Discounts',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Net Charges',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Text('${_invoiceDetails.ownerName}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('${user.name}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('${_invoiceDetails.vehicleName}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('${_invoiceDetails.vehicleNo}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('${_invoiceDetails.vehicleModel}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('${_invoiceDetails.vehicleTypeName}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('${_invoiceDetails.charges}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text(
                          '${_membership == true ? _invoiceDetails.discount : 0}%',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text(
                          '${_inputMembershipStatus == "Yes" ? _invoiceDetails.charges! * (1 - _invoiceDetails.discount! / 100) : _invoiceDetails.charges}',
                          style: TextStyle(fontSize: 20.0))
                    ]),
                  ]),
                ],
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
                TextButton(
                  child: Text(
                    'Print',
                  ),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                )
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
    if (fromSlot)
      await _getVehicleTypes(floorId: floorId);
    else
      await _getVehicleTypes();
    _loading = false;
    setState(() {});
  }

  _getFloors(int id) async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/getFloors.php"),
        body: {'vehicleTypeId': id.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _floors.clear();
      for (Map i in data) {
        _floors.add(FloorModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _getAllParkings() async {
    final response = await http.get(Uri.parse(
        "http://localhost/Registration/SDA_Project/getAllParkings.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _parkings.clear();
      for (Map i in data) {
        _parkings.add(ParkingModel.fromJson(i));
      }
      return;
    } else {
      print(response.body.toString());
    }
  }

  _getParking() async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/getAllParkings.php"),
        body: {
          'vehivleNo': _vehicleNoController.text,
          'vehivleTypeId': _vehicleTypeId.toString()
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _parkings.clear();
      for (Map i in data) {
        _invoiceDetails = ParkingModel.fromJson(i);
      }
      return;
    } else {
      print(response.body.toString());
    }
  }

  _checkMembership() async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/getVehicle.php"),
        body: {
          'vehicleNo': _vehicleNoController.text,
          'code': _membershipCodeController.text,
          'vehicleTypeId': _vehicleTypeId.toString()
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.length == 0) {
        _membership = false;
        return;
      } else {
        for (Map i in data) {
          VehicleModel vehicle = VehicleModel.fromJson(i);
          _vehicleNameController.text = vehicle.vehicleName!;
          _vehicleModelController.text = vehicle.vehicleModel.toString();
          _ownerNameController.text = vehicle.ownerName!;
        }
        _membership = true;
        return;
      }
    } else {
      print(response.body.toString());
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

  _getSlots(int floorId) async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/getSlots.php"),
        body: {'Floor_id': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _slots.clear();
      for (Map i in data) {
        _slots.add(SlotModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _addParking() async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/insertParking.php"),
        body: {
          'vehicleTypeId': _vehicleTypeId.toString(),
          'userId': user.id.toString(),
          'floorId': floorId.toString(),
          'slotId': slotId.toString(),
          'vehicleNo': _vehicleNoController.text,
          'vehicleName': _vehicleNameController.text,
          'vehicleModel': _vehicleModelController.text,
          'ownerName': _ownerNameController.text
        });
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }
}
