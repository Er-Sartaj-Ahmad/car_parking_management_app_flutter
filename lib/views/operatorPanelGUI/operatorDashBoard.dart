import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/properties.dart';
import 'package:car_parking_system/services/floorModel.dart';
import 'package:car_parking_system/views/operatorPanelGUI/manageParking/slotsView.dart';
import 'package:car_parking_system/views/operatorPanelGUI/operatorSideBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperatorDashBoard extends StatefulWidget {
  late User user;

  OperatorDashBoard({required this.user});

  @override
  State<OperatorDashBoard> createState() =>
      _OperatorDashBoardState(user: user);
}

class _OperatorDashBoardState extends State<OperatorDashBoard> {
  late User user;

  _OperatorDashBoardState({required this.user});

  bool _loading = true;
  List<FloorModel> _floors = [];
  double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: OperatorSideBar(user: user),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return AddFloorsAndSlots(
          //     userModel: userModel,
          //     floorname: "",
          //     slots: 0,
          //     id: 0,
          //   );
          // })).then((value) => _loadData());
        },
        child: Icon(Icons.search),
      ),
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _floors.isEmpty
            ? Text("No Records")
            : SingleChildScrollView(
          child: Column(
            children: [
              for (var i in _floors)
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
                                return SlotsView(
                                  user: user,floorId: i.id!,);
                              })).then((value) => _loadData());
                        },
                        leading: CircleAvatar(
                          backgroundColor:
                          cicleAvatarColor[i.id! % 7],
                          child: ClipOval(
                              child: Text(
                                "${i.name![0]}",
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
                          i.name!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Text("Total Slots: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                i.totalSlots == null
                                    ? "0"
                                    : i.totalSlots.toString(),
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
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

  _alertDialog(var i) async {
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
                await _deleteFloor(i.id!);
                await _loadData();
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
    await _getFloors();
    _loading = false;
    setState(() {});
  }

  _getFloors() async {
    final response = await http.get(
        Uri.parse("http://localhost/Registration/SDA_Project/getAllFloors.php"));
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

  _deleteFloor(int id) async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/deleteFloor.php"),
        body: {'id': id.toString()});
    if (response.statusCode == 200) {
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }
}
