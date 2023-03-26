import 'dart:convert';
import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/parkingModel.dart';
import 'package:http/http.dart' as http;

class Parking {
  int? membershipCode;
  int? vehicleNo;
  String? vehicleName;
  int? vehicleModel;
  String? ownerName;
  DateTime? registrnDateTime = DateTime.now();
  int status = 1;

  setValues(ParkingModel parkingModel) {
    this.membershipCode = parkingModel.id;
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
