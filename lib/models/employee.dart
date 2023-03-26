import 'dart:convert';
import 'package:car_parking_system/models/role.dart';
import 'package:car_parking_system/properties.dart';
import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/userModel.dart';
import 'package:http/http.dart' as http;

class Employee {
  int? id;
  String? name;
  DateTime? DOB;
  String? contactNo;
  DateTime? registrationDate;
  int status;
  Role? role;

  Employee(
      {this.id,
      this.name,
      this.DOB,
      this.contactNo,
      this.registrationDate,
      this.status = 1,
      this.role});

  getEmployees({int roleId = 0}) async {
    final response = await http.post(Uri.parse(DBHelper().getEmployeesUrl),
        body: {'role_id': roleId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var empList = [];
      for (Map i in data) {
        empList.add(UserModel.fromJson(i));
      }
      return empList;
    } else {
      print(response.body.toString());
    }
  }


  addEmployee() async {
    final response = await http.post(
        Uri.parse(
            DBHelper().addEmpUrl),
        body: {
          'role_id': this.role!.id.toString(),
          'name': this.name,
          'DOB': DateToString(this.DOB!),
          'contact': this.contactNo
        });
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }

  updateEmployee() async {
    final response = await http.post(
          Uri.parse(DBHelper().updateEmp),
          body: {
            'empId': this.id.toString(),
            'empName': this.name,
            'empDOB': DateToString(this.DOB!),
            'empContact': this.contactNo,
            'roleId': this.role!.id.toString()
          });

    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }

  deleteEmployee() async {
    final response = await http.post(
        Uri.parse(DBHelper().deleteEmpUrl),
        body: {'id': this.id.toString()});
    if (response.statusCode == 200) {
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }
}
