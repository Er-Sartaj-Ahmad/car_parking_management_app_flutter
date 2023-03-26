import 'dart:convert';

import 'package:car_parking_system/models/floor.dart';
import 'package:car_parking_system/models/slot.dart';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/models/vehicleType.dart';
import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/parkingModel.dart';
import 'package:http/http.dart' as http;

class Parking {
  int? id;
  VehicleType vehicleType = VehicleType();
  User user = User();
  Floor floor = Floor();
  Slot slot = Slot();
  int? vehicleNo;
  String? vehicleName;
  int? vehicleModel;
  String? ownerName;
  DateTime? entryDateTime = DateTime.now();
  int status = 1;

  setValues(ParkingModel parkingModel) {
    this.id = parkingModel.id;
    this.vehicleType.charges = parkingModel.charges;
    this.vehicleType.discount = parkingModel.discount;
    this.vehicleType.id = parkingModel.vehicleTypeId;
    this.vehicleType.title = parkingModel.vehicleTypeName;
    this.slot.id = parkingModel.slotId;
    this.floor.id = parkingModel.floorId;
    this.vehicleName = parkingModel.vehicleName;
    this.vehicleNo = parkingModel.vehicleNo;
    this.vehicleModel = parkingModel.vehicleModel;
    this.ownerName = parkingModel.ownerName;
  }

  getParkings(int floorId) async {
    final response = await http.post(Uri.parse(DBHelper().getParkingUrl),
        body: {'floorId': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<ParkingModel> list = [];
      for (Map i in data) {
        list.add(ParkingModel.fromJson(i));
      }
      return list;
    } else {
      print(response.body.toString());
    }
  }

  addParking(int floorId) async {
    final response = await http.post(Uri.parse(DBHelper().getParkingUrl),
        body: {'floorId': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<ParkingModel> list = [];
      for (Map i in data) {
        list.add(ParkingModel.fromJson(i));
      }
      return list;
    } else {
      print(response.body.toString());
    }
  }

  removeParking(int floorId) async {
    final response = await http.post(Uri.parse(DBHelper().getParkingUrl),
        body: {'floorId': floorId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<ParkingModel> list = [];
      for (Map i in data) {
        list.add(ParkingModel.fromJson(i));
      }
      return list;
    } else {
      print(response.body.toString());
    }
  }
}
