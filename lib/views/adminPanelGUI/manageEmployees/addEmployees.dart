import 'package:car_parking_system/models/role.dart';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/properties.dart';
import 'package:car_parking_system/services/roleModel.dart';
import 'package:car_parking_system/widgets/myDropdownSearch.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/material.dart';
import '../../../widgets/myButton.dart';

class AddEmployees extends StatefulWidget {
  User employee;
  bool update;

  AddEmployees({required this.employee, required this.update});

  @override
  State<AddEmployees> createState() =>
      _AddFloorsAndSlotsState(employee: this.employee, update: update);
}

class _AddFloorsAndSlotsState extends State<AddEmployees> {
  User employee;
  bool update;

  _AddFloorsAndSlotsState({required this.employee, required this.update});

  User? user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  String? _nameInputError;
  String? _passwordIncputError;
  String? _contactInputError;
  String? _roleInputError;
  String? _userNameInputError;
  DateTime date = DateTime.now();
  List<Role> _roles = [];
  double? _width;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    MyTextField(
                      width: _width! * 0.9,
                      controller: _nameController,
                      labelText: 'Employee Name',
                      hintText: 'Enter Employee Name',
                      errorText: _nameInputError,
                      onChanged: (v) {
                        if (v != null) {
                          _nameInputError = null;
                          setState(() {});
                        }
                      },
                    ),
                    MyButton(
                        name: "Date of Birth: " + DateToString(date),
                        onPressed: () {
                          selecdate(context);
                        }),
                    MyTextField(
                      width: _width! * 0.9,
                      controller: _contactController,
                      labelText: 'Contact',
                      hintText: 'Enter Contact',
                      errorText: _contactInputError,
                      onChanged: (v) {
                        if (v != null) {
                          _contactInputError = null;
                          setState(() {});
                        }
                      },
                    ),
                    MyDropdownSearch(
                      width: _width! * 0.9,
                      items: [for (Role r in _roles) r.jobTitle!],
                      errorText: _roleInputError,
                      labelText: 'Role',
                      hintText: 'Enter Role',
                      onChanged: (value) async {
                        _roleInputError = null;
                        _roleController.text = value!;
                        setState(() {});
                      },
                      selectedItem: _roleController.text,
                    ),
                    (_roleController.text.toUpperCase() == "ADMIN" ||
                            _roleController.text.toUpperCase() == "OPERATOR")
                        ? Column(
                            children: [
                              MyTextField(
                                width: _width! * 0.9,
                                controller: _userNameController,
                                labelText: 'User Name',
                                hintText: 'Enter User Name',
                                errorText: _userNameInputError,
                                onChanged: (v) {
                                  if (v != null) {
                                    _userNameInputError = null;
                                    setState(() {});
                                  }
                                },
                              ),
                              MyTextField(
                                width: _width! * 0.9,
                                controller: _passwordController,
                                labelText: 'Password',
                                hintText: 'Enter Password',
                                errorText: _passwordIncputError,
                                onChanged: (v) {
                                  if (v != null) {
                                    _passwordIncputError = null;
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          )
                        : SizedBox(),
                    MyButton(
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty &&
                            _contactController.text.isNotEmpty &&
                            ((_passwordController.text.isNotEmpty &&
                                    _userNameController.text.isNotEmpty) ||
                                (_roleController.text.toUpperCase() !=
                                        "ADMIN" &&
                                    _roleController.text.toUpperCase() !=
                                        "OPERATOR"))) {
                          if (!update) {
                            user = User();
                            user!.role = Role();
                            user!.role!.id = _getRoleId();
                            user!.name = _nameController.text;
                            user!.DOB = date;
                            user!.contactNo = _contactController.text;
                            await user!.addEmployee();
                            if (_passwordController.text.isNotEmpty) {
                              user!.userName = _userNameController.text;
                              user!.password = _passwordController.text;
                              await user!.addUser();
                            }
                            _confirmatoinDialog();
                            _nameController.clear();
                            _contactController.clear();
                            _userNameController.clear();
                            _passwordController.clear();
                            _roleController.text = _roles[0].jobTitle!;
                            date = DateTime.now();
                            setState(() {});
                            return;
                          } else {
                            await _updateEmployee();
                            _confirmatoinDialog();
                            setState(() {});
                            return;
                          }
                        }
                        if (_nameController.text.isEmpty) {
                          _nameInputError = "Required";
                        }
                        if (_contactController.text.isEmpty) {
                          _contactInputError = "Required";
                        }
                        if (_roleController.text.isEmpty) {
                          _roleInputError = "Required";
                        }
                        if (_passwordController.text.isEmpty) {
                          _passwordIncputError = "Required";
                        }
                        if (_userNameController.text.isEmpty) {
                          _userNameInputError = "Required";
                        }
                        setState(() {});
                      },
                      name: update ? "Update" : "Save",
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  _confirmatoinDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Oparation Successful',
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Close',
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
              elevation: 20.0,
            ));
  }

  Future<Null> selecdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(3000));
    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  @override
  initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    await _getRoles();
    if (update) {
      _nameController.text = employee.name!;
      date = employee.DOB!;
      _contactController.text = employee.contactNo!;
      _roleController.text = employee.role!.jobTitle!;
      _userNameController.text = employee.userName.toString();
      _passwordController.text = employee.password.toString();
    } else {
      _roleController.text = _roles[0].jobTitle!;
    }
    _loading = false;
    setState(() {});
  }

  _getRoles() async {
    List list = await Role().getRoles();
    for(RoleModel i in list)
      {
        Role role = Role();
        role.setValues(i);
        _roles.add(role);
      }
  }

  _getRoleId() {
    for (Role r in _roles) {
      if (r.jobTitle == _roleController.text) {
        return r.id;
      }
    }
  }

  _updateEmployee() async {
    if (employee.role!.jobTitle!.toUpperCase() == "ADMIN" ||
        employee.role!.jobTitle!.toUpperCase() == "OPERATOR") {
      user = User();
      user!.id = employee.id;
      user!.name = _nameController.text;
      user!.DOB = date;
      user!.contactNo = _contactController.text;
      user!.role = Role();
      user!.role!.id = _getRoleId();
      user!.userName = _userNameController.text;
      user!.password = _passwordController.text;
      await user!.updateUser();
    } else {
      user = User();
      user!.id = employee.id;
      user!.name = _nameController.text;
      user!.DOB = date;
      user!.contactNo = _contactController.text;
      user!.role = Role();
      user!.role!.id = _getRoleId();
      user!.updateEmployee();
    }
  }
}
