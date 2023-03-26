import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/userModel.dart';
import 'package:car_parking_system/services/vehicleTypeModel.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageVehicleTypesAndCharges/addVehicleTypesAndCharges.dart';
import 'package:car_parking_system/properties.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageVehicleTypesAndCharges extends StatefulWidget {


  @override
  State<ManageVehicleTypesAndCharges> createState() =>
      _ManageVehicleTypesAndChargesState();
}

class _ManageVehicleTypesAndChargesState
    extends State<ManageVehicleTypesAndCharges> {


  late bool _loading;
  List<VehicleTypeModel> _vehicleTypeModel = [];
  double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddVehicleTypesAndCharges();
          })).then((value) => _loadData());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _vehicleTypeModel.isEmpty
                ? Text("No Records")
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i in _vehicleTypeModel)
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
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        cicleAvatarColor[i.id! % 7],
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
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                    'Are you sure?',
                                                  ),
                                                  content: Text(
                                                    "You want to delete?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Cancel',
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'Yes',
                                                      ),
                                                      onPressed: () async {
                                                        await _deleteVehicleType(
                                                            i.id!);
                                                        await _loadData();
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                    )
                                                  ],
                                                  elevation: 20.0,
                                                ));
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  title: Text(
                                    i.title!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                          "Charges:",
                                          style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              )),
                                      Text(i.charges.toString(),
                                          style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              )),
                                      Text(" & Disount:",
                                          style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              )),
                                      Text(i.discount.toString() +
                                              "%",
                                          style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              )),
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
    _loadData();
    super.initState();
  }

  _loadData() async {
    setState(() {
      _loading = true;
    });
    await _getVehicleTypes();
    _loading = false;
    setState(() {});
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

  _deleteVehicleType(int id) async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/deleteVehicleType.php"),
        body: {'id': id.toString()});
    if (response.statusCode == 200) {
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }
}
