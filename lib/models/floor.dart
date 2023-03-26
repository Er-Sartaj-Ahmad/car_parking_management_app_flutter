import 'dart:convert';
import 'package:car_parking_system/models/slot.dart';
import 'package:car_parking_system/models/vehicleType.dart';
import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/floorModel.dart';
import 'package:http/http.dart' as http;

class Floor {
  int? id;
  String? name;
  int? totalSlots;
  int status = 1;
  List<VehicleType> vehicleTypes = [];
  List<Slot> slots = [];

  setValues(FloorModel floorModel) {
    this.id = floorModel.id;
    this.name = floorModel.name;
    this.totalSlots = floorModel.totalSlots;
  }

  getFloors() async {
    final response = await http.get(Uri.parse(DBHelper().getFloorsUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<FloorModel> _floorModels = [];
      for (Map i in data) {
        _floorModels.add(FloorModel.fromJson(i));
      }
      return _floorModels;
    } else {
      print(response.body.toString());
    }
  }

  deleteFloor() async {
    final response = await http.post(Uri.parse(DBHelper().deleteFloorUrl),
        body: {'id': this.id.toString()});
    if (response.statusCode == 200) {
      print("deleted successfully");
    } else {
      print(response.body.toString());
    }
  }

  addfloor() async {
    final response = await http
        .post(Uri.parse(DBHelper().addFloorsUrl), body: {'name': this.name});
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }

  addslots() async {
    final response = await http.post(Uri.parse(DBHelper().addSlotsUrl),
        body: {'floorName': this.name, 'slots': this.totalSlots.toString()});
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }

  addSupportiveVehileType() async {
    for (VehicleType i in this.vehicleTypes) {
      final response = await http.post(
          Uri.parse(DBHelper().suportiveVehicleUrl),
          body: {'floorName': this.name, 'vehicleTypeid': i.id.toString()});
      if (response.statusCode == 200) {
        print(response.body.toString());
      } else {
        print(response.body.toString());
      }
    }
  }

  clearSlots() async {
    final response = await http.post(
        Uri.parse(DBHelper().clearSlotsUrl),
        body: {'floorId': this.id.toString()});
    if (response.statusCode == 200) {
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }

}
