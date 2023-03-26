import 'package:car_parking_system/services/userModel.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddVehicleTypesAndCharges extends StatefulWidget {


  @override
  State<AddVehicleTypesAndCharges> createState() =>
      _AddVehicleTypesAndChargesState();
}

class _AddVehicleTypesAndChargesState extends State<AddVehicleTypesAndCharges> {
  double? _width;
  TextEditingController _typeController = TextEditingController();
  TextEditingController _chargesController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  String? _typeInputError;
  String? _chargesInputError;
  String? _discountInputError;

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
                controller: _typeController,
                  labelText: 'VehicleType',
                  hintText: 'Enter VehicleType',
                  errorText: _typeInputError,
                onChanged: (v) {
                  if (v != null) {
                    _typeInputError = null;
                    setState(() {});
                  }
                },
              ),
              MyTextField(
                width: _width! * 0.9,
                controller: _chargesController,
                  labelText: 'Parking Charges',
                  hintText: 'Enter Parking Charges',
                  errorText: _chargesInputError,
                onChanged: (v) {
                  if (v != null) {
                    _chargesInputError = null;
                    setState(() {});
                  }
                },
              ),
              MyTextField(
                width: _width! * 0.9,
                controller: _discountController,
                  labelText: 'Membership Discount %',
                  hintText: 'Enter Membership Discount %',
                  errorText: _discountInputError,
                onChanged: (v) {
                  if (v != null) {
                    _discountInputError = null;
                    setState(() {});
                  }
                },
              ),
              MyButton(
                onPressed: () async {
                  if (_typeController.text.isNotEmpty &&
                      _chargesController.text.isNotEmpty &&
                      _discountController.text.isNotEmpty &&
                      int.parse(_discountController.text) >= 0 &&
                      int.parse(_discountController.text) <= 100) {
                    await _insertData();
                    _typeController.clear();
                    _chargesController.clear();
                    _discountController.clear();
                    return;
                  }
                  if (_typeController.text.isEmpty) {
                    _typeInputError = "Type can't be empty";
                  }
                  if (_chargesController.text.isEmpty) {
                    _chargesInputError = "Charges can't be empty";
                  }
                  if (_discountController.text.isEmpty) {
                    _discountInputError = "Discount can't be empty";
                  }
                  if (int.parse(_discountController.text) < 0) {
                    _discountInputError = "Discount can't be less than zero";
                  }
                  if (int.parse(_discountController.text) > 100) {
                    _discountInputError =
                        "Discount can't be greater than 100";
                  }
                  setState(() {});
                },
                name: "Save",
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
            "http://localhost/Registration/SDA_Project/insertVehicleType.php"),
        body: {
          'Type': _typeController.text,
          'Charges': _chargesController.text,
          'Discount': _discountController.text
        });
    if (response.statusCode == 200) {
      print("done");
    } else
      print("not done");
  }
}
