import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRolesAndSalaries extends StatefulWidget {


  @override
  State<AddRolesAndSalaries> createState() =>
      _AddRolesAndSalariesState();
}

class _AddRolesAndSalariesState extends State<AddRolesAndSalaries> {
  double? _width;
  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  String? _jobTitleInputError;
  String? _salaryInputError;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyTextField(
                width: _width! * 0.9,
                controller: _jobTitleController,
                  labelText: 'Job Title',
                  hintText: 'Enter Job Title',
                  errorText: _jobTitleInputError,
                onChanged: (v) {
                  if (v != null) {
                    _jobTitleInputError = null;
                    setState(() {});
                  }
                },
              ),
              MyTextField(
                width: _width! * 0.9,
                controller: _salaryController,
                  labelText: 'Salary',
                  hintText: 'Enter Salary',
                  errorText: _salaryInputError,
                onChanged: (v) {
                  if (v != null) {
                    _salaryInputError = null;
                    setState(() {});
                  }
                },
              ),
              MyButton(
                onPressed: () async {
                  if (_jobTitleController.text.isNotEmpty &&
                      _salaryController.text.isNotEmpty) {
                    await _insertData();
                    _jobTitleController.clear();
                    _salaryController.clear();
                    return;
                  }
                  if (_jobTitleController.text.isEmpty) {
                    _jobTitleInputError = "JobTitle can't be empty";
                  }
                  if (_salaryController.text.isEmpty) {
                    _salaryInputError = "Salary can't be empty";
                  }
                  setState(() {});
                },
                name:
                  "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }

  _insertData() async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/insertRole.php"),
        body: {
          'JobTitle': _jobTitleController.text,
          'Salary': _salaryController.text,
        });
    if (response.statusCode == 200) {
      print("done");
    } else
      print("not done");
  }
}
