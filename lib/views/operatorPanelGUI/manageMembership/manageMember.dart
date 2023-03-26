import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/properties.dart';
import 'package:car_parking_system/views/operatorPanelGUI/manageMembership/addMember.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/vehicleModel.dart';

class ManageMembers extends StatefulWidget {
  late User user;

  ManageMembers({required this.user});

  @override
  State<ManageMembers> createState() =>
      _ManageMembersState(user: user);
}

class _ManageMembersState extends State<ManageMembers> {
  User user;

  _ManageMembersState({required this.user});

  late bool _loading;
  List<VehicleModel> _vehicles = [];
  double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddMembers(user: user,update: false,vehicle: VehicleModel(membershipCode: 0),);
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
            : _vehicles.isEmpty
                ? Text("No Records")
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i in _vehicles)
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
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return AddMembers(user: user,update: true,vehicle: i,);
                                    })).then((value) => _loadData());
                                  },
                                  isThreeLine: true,
                                  enableFeedback: true,
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        cicleAvatarColor[i.membershipCode! % 7],
                                    child: ClipOval(
                                        child: Text(
                                      "${i.vehicleNo![0]}",
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
                                        _showDialog(i);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  title: Text(
                                    i.vehicleNo!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text("Owner Name: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(i.ownerName!,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(" & Membership Code: ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(i.membershipCode!.toString(),
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

  _showDialog(VehicleModel i) {
    return showDialog(
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
                    Navigator.pop(context, true);
                  },
                ),
                TextButton(
                  child: Text(
                    'Yes',
                  ),
                  onPressed: () async {
                    await _deleteMember(i.membershipCode!);
                    Navigator.pop(context, true);
                    _loadData();
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
    _loading = true;
    await _getMembers();
    _loading = false;
    setState(() {});
  }

  _getMembers() async {
    final response = await http.get(Uri.parse(
        "http://localhost/Registration/SDA_Project/getVehicle.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _vehicles.clear();
      for (Map i in data) {
        _vehicles.add(VehicleModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _deleteMember(int id) async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/deleteMember.php"),
        body: {'memberShipCode': id.toString()});
    if (response.statusCode == 200) {
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }
}
