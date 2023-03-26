import 'package:car_parking_system/models/floor.dart';
import 'package:car_parking_system/models/parking.dart';
import 'package:car_parking_system/models/slot.dart';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/slotModel.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:flutter/material.dart';

import '../../../services/parkingModel.dart';

class ManageSlots extends StatefulWidget {
  late User user;
  late int floorId;

  ManageSlots({required this.user, required this.floorId});

  @override
  State<ManageSlots> createState() =>
      _ManageSlotsState(user: user, floorId: floorId);
}

class _ManageSlotsState extends State<ManageSlots> {
  late int floorId;
  late User user;

  _ManageSlotsState({required this.user, required this.floorId});

  TextEditingController _slotController = TextEditingController();
  String? _slotInputError;
  int _totalFree = 0;
  bool _loading = true;
  List<Slot> _slots = [];
  List<Parking> _parkings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyButton(
              onPressed: () async {
                if (_totalFree == _slots.length) _alertDialog(floorId);
              },
              name: "Delete All",
              color: _totalFree == _slots.length ? Colors.red : Colors.grey,
            ),
            Container(
                child: IconButton(
                    onPressed: () async {
                      await _addSlotDialog();
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.lightGreen)),
          ],
        ),
      ),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        ? SizedBox()
                                        : Container(
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                            ),
                                            child: IconButton(
                                                onPressed: () {
                                                  if (_slots[index].free == 1)
                                                    _alertDialog(
                                                        _slots[index].id!,
                                                        all: false);
                                                },
                                                icon: Icon(Icons.delete,
                                                    color: Colors.white)),
                                          )
                                  ],
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
                                SizedBox()
                              ],
                            ));
                      },
                    ),
                  ),
      ),
    );
  }

  _addSlotDialog() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: TextField(
                autocorrect: true,
                autofocus: true,
                controller: _slotController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number of Slots',
                  hintText: 'Enter Number of Slots',
                  errorText: _slotInputError,
                ),
                onChanged: (v) {
                  if (v != null) {
                    _slotInputError = null;
                    setState(() {});
                  }
                },
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
                    'Save',
                  ),
                  onPressed: () async {
                    if (_slotController.text.isNotEmpty) {
                      await Slot()
                          .addslots(floorId, int.parse(_slotController.text));
                      _slotController.clear();
                      _loadData();
                      Navigator.pop(context, true);
                    }
                  },
                )
              ],
              elevation: 20.0,
            ));
  }

  _alertDialog(int i, {all = true}) async {
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
                    if (all) {
                      Floor floor = Floor();
                      floor.id = i;
                      await floor.clearSlots();
                    } else
                      await Slot().deleteSlot(i);
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
    _totalFree = 0;
    for (var a in _slots) {
      if (a.free == 1) _totalFree++;
    }
    await _getAllParkings();
    _loading = false;
    setState(() {});
  }

  _getSlots() async {
    List list = await Slot().getSlots(floorId);
    _slots.clear();
    for (SlotModel s in list) {
      Slot slot = Slot();
      slot.setValues(s);
      _slots.add(slot);
    }
  }

  _getAllParkings() async {
    _parkings.clear();
    List list = await Parking().getParkings(floorId);
    for (int i = 0; i < _slots.length; i++) {
      _parkings.add(Parking());
    }
    for (int i = 0; i < _slots.length; i++) {
      for (var j in list) {
        if (_slots[i].id == j.slotId) {
          Parking parking = Parking();
          parking.setValues(j);
          _parkings[i] = parking;
        }
      }
    }
    return;
  }
}
