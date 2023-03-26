import 'dart:convert';

import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/slotModel.dart';
import 'package:car_parking_system/views/operatorPanelGUI/manageParking/addParking.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../services/parkingModel.dart';

class SlotsView extends StatefulWidget {
  late User user;
  late int floorId;

  SlotsView({required this.user, required this.floorId});

  @override
  State<SlotsView> createState() =>
      _SlotsViewState(user: user, floorId: floorId);
}

class _SlotsViewState extends State<SlotsView> {
  late int floorId;
  late User user;

  _SlotsViewState({required this.user, required this.floorId});

  bool _loading = true;
  List<SlotModel> _slots = [];
  List<ParkingModel> _parkings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _slots.isEmpty
                ? Text("No Records")
                : Container(
                    padding: EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: _slots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            color: _slots[index].free == 1
                                ? Colors.green
                                : Colors.red,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: ClipOval(
                                        child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.fontSize,
                                      ),
                                    )),
                                  ),
                                ),
                                _slots[index].free == 0
                                    ? Center(
                                        child: Container(
                                          color: Colors.yellow,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Owner Name: ${_parkings[index].ownerName}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.fontSize,
                                                  ),
                                                ),
                                                Text(
                                                  "Vehicle Number: ${_parkings[index].vehicleNo}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.fontSize,
                                                  ),
                                                ),
                                                Text(
                                                  "Vehicle Name: ${_parkings[index].vehicleName}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.fontSize,
                                                  ),
                                                ),
                                                Text(
                                                  "Vehicle Model: ${_parkings[index].vehicleModel}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.fontSize,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: FloatingActionButton(
                                        child: Icon(_slots[index].free == 1
                                            ? Icons.add
                                            : Icons.remove),
                                        onPressed: () async {
                                          if (_slots[index].free == 1)
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return AddParking(
                                                user: user,
                                                fromSlot: true,
                                                floorId: floorId,
                                                slotId: _slots[index].id!,
                                              );
                                            })).then((value) => _loadData());
                                          else
                                            await _alertDialog(
                                                _parkings[index]);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ));
                      },
                    ),
                  ),
      ),
    );
  }

  _alertDialog(ParkingModel p) async {
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
                    await _removeParking(p);
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
    await _getSlots();
    await _getAllParkings();
    _loading = false;
    setState(() {});
  }

  _getSlots() async {
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

  _getAllParkings() async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/getAllParkings.php"),
        body: {'floorId': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _parkings.clear();
      List<ParkingModel> _tempParkings = [];
      for (Map i in data) {
        _tempParkings.add(ParkingModel.fromJson(i));
      }
      for (int i = 0; i < _slots.length; i++) {
        _parkings.add(ParkingModel());
      }
      for (int i = 0; i < _slots.length; i++) {
        for (var j in _tempParkings) {
          if (_slots[i].id == j.slotId) {
            _parkings[i] = j;
          }
        }
      }
      return;
    } else {
      print(response.body.toString());
    }
  }

  _removeParking(ParkingModel p) async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/deleteParking.php"),
        body: {
          'vehicleNo': p.vehicleNo.toString(),
          'vehicleOwnerName': p.ownerName
        });
    print(p.vehicleNo);
    print(p.ownerName);
    if (response.statusCode == 200) {
      print("removed successfully");
      return;
    } else {
      print(response.body.toString());
      return;
    }
  }
}
