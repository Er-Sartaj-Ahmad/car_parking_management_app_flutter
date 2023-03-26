import 'dart:convert';

import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/vehicleTypeModel.dart';
import 'package:http/http.dart' as http;

class VehicleType {
  int? id;
  String? title;
  int? charges;
  int? discount;
  int status;

  VehicleType(
      {this.id, this.title, this.charges, this.discount, this.status = 1});

  setValues(VehicleTypeModel vehicleTypeModel) {
    this.id = vehicleTypeModel.id;
    this.title = vehicleTypeModel.title;
    this.charges = vehicleTypeModel.charges;
    this.discount = vehicleTypeModel.discount;
  }

  getVehicleTypes() async {
    final response = await http.get(Uri.parse(DBHelper().getVTUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<VehicleTypeModel> list = [];
      for (Map i in data) {
        list.add(VehicleTypeModel.fromJson(i));
      }
      return list;
    } else {
      return response.body.toString();
    }
  }

  addVehicleTypes() async {
    final response = await http.get(Uri.parse(DBHelper().getVTUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<VehicleTypeModel> list = [];
      for (Map i in data) {
        list.add(VehicleTypeModel.fromJson(i));
      }
      return list;
    } else {
      return response.body.toString();
    }
  }
  deleteVehicleTypes() async {
    final response = await http.get(Uri.parse(DBHelper().getVTUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<VehicleTypeModel> list = [];
      for (Map i in data) {
        list.add(VehicleTypeModel.fromJson(i));
      }
      return list;
    } else {
      return response.body.toString();
    }
  }
  updateVehicleTypes() async {
    final response = await http.get(Uri.parse(DBHelper().getVTUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<VehicleTypeModel> list = [];
      for (Map i in data) {
        list.add(VehicleTypeModel.fromJson(i));
      }
      return list;
    } else {
      return response.body.toString();
    }
  }
}
