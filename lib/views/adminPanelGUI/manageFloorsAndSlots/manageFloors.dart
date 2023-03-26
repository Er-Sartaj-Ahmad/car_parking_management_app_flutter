import 'package:car_parking_system/models/floor.dart';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/floorModel.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageFloorsAndSlots/addFloorsAndSlots.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageFloorsAndSlots/manageSlots.dart';
import 'package:car_parking_system/properties.dart';
import 'package:flutter/material.dart';

class ManageFloors extends StatefulWidget {
  late User user;

  ManageFloors({required this.user});

  @override
  State<ManageFloors> createState() => _ManageFloorsState(user: user);
}

class _ManageFloorsState extends State<ManageFloors> {
  late User user;

  _ManageFloorsState({required this.user});

  bool _loading = true;
  List<Floor> _floors = [];
  double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddFloorsAndSlots(
              floorname: "",
              slots: 0,
              id: 0,
            );
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
            : _floors.isEmpty
                ? Text("No Records")
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (Floor i in _floors)
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
                                      return ManageSlots(
                                        user: user,
                                        floorId: i.id!,
                                      );
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
                                  trailing: IconButton(
                                      onPressed: () async {
                                        if (i.totalSlots == null)
                                          await _alertDialog(i);
                                      },
                                      icon: Icon(
                                          i.totalSlots == null
                                              ? Icons.delete
                                              : Icons.edit,
                                          color: Colors.red)),
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

  _alertDialog(Floor i) async {
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
                    await i.deleteFloor();
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
    List list = await Floor().getFloors();
    _floors.clear();
    for (FloorModel i in list) {
      Floor floor = Floor();
      floor.setValues(i);
      _floors.add(floor);
    }
  }
}
