import 'dart:convert';

import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/roleModel.dart';
import 'package:http/http.dart' as http;

class Role {
  int? id;
  String? jobTitle;
  int? salary;
  DateTime? registrationDate;
  int status;

  Role(
      {this.id,
      this.jobTitle,
      this.salary,
      this.registrationDate,
      this.status = 1});


  setValues(RoleModel roleModel)
  {
    this.id = roleModel.id;
    this.jobTitle = roleModel.jobTitle;
    this.salary = roleModel.salary;
    this.registrationDate = DateTime.parse(roleModel.registrationDate!);
  }
  getRoles() async {
    final response = await http.get(
        Uri.parse(DBHelper().getRolesUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<RoleModel> _roleModels =  [];
      for (Map i in data) {
        _roleModels.add(RoleModel.fromJson(i));
      }
      return _roleModels;
    } else {
      print(response.body.toString());
    }
  }

  addRoles() async {
    final response = await http.get(
        Uri.parse(DBHelper().getRolesUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<RoleModel> _roleModels =  [];
      for (Map i in data) {
        _roleModels.add(RoleModel.fromJson(i));
      }
      return _roleModels;
    } else {
      print(response.body.toString());
    }
  }

  daleteRoles() async {
    final response = await http.get(
        Uri.parse(DBHelper().getRolesUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<RoleModel> _roleModels =  [];
      for (Map i in data) {
        _roleModels.add(RoleModel.fromJson(i));
      }
      return _roleModels;
    } else {
      print(response.body.toString());
    }
  }
  updateRoles() async {
    final response = await http.get(
        Uri.parse(DBHelper().getRolesUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<RoleModel> _roleModels =  [];
      for (Map i in data) {
        _roleModels.add(RoleModel.fromJson(i));
      }
      return _roleModels;
    } else {
      print(response.body.toString());
    }
  }
}
