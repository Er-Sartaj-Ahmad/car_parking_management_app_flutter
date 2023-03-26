import 'dart:convert';
import 'package:car_parking_system/models/employee.dart';
import 'package:car_parking_system/models/role.dart';
import 'package:car_parking_system/properties.dart';
import 'package:car_parking_system/services/DBhelper.dart';
import 'package:car_parking_system/services/userModel.dart';
import 'package:http/http.dart' as http;

class User extends Employee {
  String? userName;
  String? password;

  User({
    this.userName,
    this.password,
  });

  setValues(UserModel userModel) {
    this.role = new Role();
    this.id = userModel.id;
    this.name = userModel.name;
    this.DOB = DateTime.parse(userModel.dob!);
    this.contactNo = userModel.contact;
    this.registrationDate = DateTime.parse(userModel.registrationDate!);
    this.role!.jobTitle = userModel.jobTitle;
    this.role!.salary = userModel.salary;
    this.userName = userModel.username;
    this.password = userModel.password;
  }

  login(userName, password) async {
    final response = await http.post(Uri.parse(DBHelper().loginUrl),
        body: {'USER_NAME': userName, 'USER_PASSWORD': password});
    if (response.statusCode == 200) {
      // print(response.body);
      var data = jsonDecode(response.body);
      if (data.length == 0) {
        return false;
      } else {
        UserModel _userModel = UserModel.fromJson(data[0]);
        this.setValues(_userModel);
        return true;
      }
    }
  }

  addUser() async {
    final response = await http.post(Uri.parse(DBHelper().addUserUrl), body: {
      'empName': this.name,
      'password': this.password,
      'username': this.userName
    });
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }

  updateUser() async {
    final response = await http.post(Uri.parse(DBHelper().updateEmp), body: {
      'empId': this.id.toString(),
      'empName': this.name,
      'empDOB': DateToString(this.DOB!),
      'empContact': this.contactNo,
      'roleId': this.role!.id.toString(),
      'userName': this.userName,
      'password': this.password
    });
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.body.toString());
    }
  }
}
