import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/roleModel.dart';
import 'package:car_parking_system/services/userModel.dart';
import 'package:car_parking_system/views/adminPanelGUI/adminSideBar.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageEmployees/manageEmployees.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageFloorsAndSlots/manageFloors.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageRolesAndSalaries/manageRolesAndSalaries.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageVehicleTypesAndCharges/manageVehicleTypesAndCharges.dart';
import 'package:http/http.dart' as http;
import 'package:car_parking_system/services/floorModel.dart';
import 'package:car_parking_system/services/vehicleTypeModel.dart';
import 'package:flutter/material.dart';

import '../../properties.dart';

class AdminDashBoard extends StatefulWidget {
  late User user;

  AdminDashBoard({required this.user});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState(user: user);
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  late User user;

  _AdminDashBoardState({required this.user});

  bool _loading = true;
  List<VehicleTypeModel> _vehicleTypeModel = [];
  List<FloorModel> _floorModels = [];
  List<UserModel> _employees = [];
  List<RoleModel> _roleModels = [];
  double? _width;
  List<String> _list = ["Employees", "Floors", "VehicleTypes", "Roles"];

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: AdminSideBar(user: user),
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
                    for (String i in _list)
                      Card(
                        margin: EdgeInsets.only(
                            left: _width! * 0.05,
                            right: _width! * 0.05,
                            top: 10,
                            bottom: 10),
                        elevation: 5,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return i == "Employees"
                                      ? ManageEmployees(user: user)
                                      : i == "Floors"
                                          ? ManageFloors(user: user)
                                          : i == "Roles"
                                              ? ManageRolesAndSalaries(
                                                  user: user,
                                                )
                                              : ManageVehicleTypesAndCharges();
                                })).then((value) => _loadData());
                              },
                              leading: CircleAvatar(
                                backgroundColor:
                                    cicleAvatarColor[_list.indexOf(i) % 7],
                                child: ClipOval(
                                    child: Text(
                                  "${i[0]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.fontSize,
                                  ),
                                )),
                              ),
                              title: Text(
                                i,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Text("Total ${i}: ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "${i == "Employees" ? _employees.length : i == "Floors" ? _floorModels.length : i == "Roles" ? _roleModels.length : _vehicleTypeModel.length}",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              focusColor: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  initState() {
    user.role!.id = 0;
    _loadData();
    super.initState();
  }

  _loadData() async {
    setState(() {
      _loading = true;
    });
    await _getEmployees();
    await _getFloors();
    await _getVehicleTypes();
    await _getRoles();
    _loading = false;
    setState(() {});
  }

  _getRoles() async {
    final response = await http.get(
        Uri.parse("http://localhost/Registration/SDA_Project/getRoles.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _roleModels.clear();
      for (Map i in data) {
        _roleModels.add(RoleModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _getFloors() async {
    final response = await http.get(Uri.parse(
        "http://localhost/Registration/SDA_Project/getAllFloors.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _floorModels.clear();
      for (Map i in data) {
        _floorModels.add(FloorModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _getEmployees() async {
    final response = await http.get(Uri.parse(
        "http://localhost/Registration/SDA_Project/getEmployees.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _employees.clear();
      for (Map i in data) {
        _employees.add(UserModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _getVehicleTypes() async {
    final response = await http.get(Uri.parse(
        "http://localhost/Registration/SDA_Project/getVehicleTypes.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _vehicleTypeModel.clear();
      for (Map i in data) {
        _vehicleTypeModel.add(VehicleTypeModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }
}
