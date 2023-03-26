import 'dart:convert';

import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RemoveParking extends StatefulWidget {

  @override
  State<RemoveParking> createState() =>
      _RemoveParkingState();
}

class _RemoveParkingState extends State<RemoveParking> {

  double? _height;
  TextEditingController _vehicleNoController = TextEditingController();
  TextEditingController _vehicleOwnerNameController = TextEditingController();
  String? _vehicleNoInputError;
  String? _vehicleOwnerNameInputError;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: _height! * 0.05,
                        right: _height! * 0.05,
                        top: 10,
                        bottom: 10),
                    child: Container(
                      width: _height! * 0.4,
                      child: TextField(
                        controller: _vehicleNoController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Vehicle Number',
                          hintText: 'Enter Vehicle Number',
                          errorText: _vehicleNoInputError,
                        ),
                        onChanged: (v) {
                          _vehicleNoInputError = null;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: _height! * 0.05,
                        right: _height! * 0.05,
                        top: 10,
                        bottom: 10),
                    child: Container(
                      width: _height! * 0.4,
                      child: TextField(
                        controller: _vehicleOwnerNameController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Owner Name',
                          hintText: 'Enter Owner Name',
                          errorText: _vehicleOwnerNameInputError,
                        ),
                        onChanged: (v) {
                          _vehicleOwnerNameInputError = null;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: _height! * 0.05,
                    right: _height! * 0.05,
                    top: 10,
                    bottom: 10),
                child: MyButton(
                  onPressed: () async {
                    if (_vehicleNoController.text.isNotEmpty &&
                        _vehicleOwnerNameController.text.isNotEmpty) {
                      await _removeParking();
                      setState(() {});
                      return;
                    }
                    if (_vehicleNoController.text.isEmpty)
                      _vehicleNoInputError = "Required";
                    if (_vehicleOwnerNameController.text.isEmpty)
                      _vehicleOwnerNameInputError = "Required";
                    setState(() {});
                  },
                  name: "Submit",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _removeParking() async {
    final response = await http.post(
        Uri.parse(
            "http://localhost/Registration/SDA_Project/deleteParking.php"),
        body: {
          'vehicleNo': _vehicleNoController.text,
          'vehicleOwnerName': _vehicleOwnerNameController.text
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.length == 0) {
        _vehicleOwnerNameInputError = "Invalid";
        _vehicleNoInputError = "Invalid";
        setState(() {});
      } else {
        _vehicleNoController.clear();
        _vehicleOwnerNameController.clear();
        _vehicleNoInputError = null;
        _vehicleOwnerNameInputError = null;
        print("removed successfully");
      }
      return;
    } else {
      print(response.body.toString());
      return;
    }
  }
}
