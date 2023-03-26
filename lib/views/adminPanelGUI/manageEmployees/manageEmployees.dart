import 'package:car_parking_system/models/employee.dart';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageEmployees/addEmployees.dart';
import 'package:car_parking_system/properties.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageEmployees extends StatefulWidget {
  late User user;

  ManageEmployees({required this.user});

  @override
  State<ManageEmployees> createState() => _ManageEmployeesState(user: user);
}

class _ManageEmployeesState extends State<ManageEmployees> {
  late User user;

  _ManageEmployeesState({required this.user});

  late bool _loading;
  List<User> _employees = [];
  double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddEmployees(
              employee: User(),
              update: false,
            );
          })).then((value) => _loadData());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _employees.isEmpty
                ? Text("No Records")
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i in _employees)
                          Card(
                            margin: EdgeInsets.only(
                                left: _width! * 0.05,
                                right: _width! * 0.05,
                                top: 10,
                                bottom: 10),
                            elevation: 5,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AddEmployees(
                                        employee: i,
                                        update: true,
                                      );
                                    })).then((value) => _loadData());
                                  },
                                  isThreeLine: true,
                                  enableFeedback: true,
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        cicleAvatarColor[i.id! % 7],
                                    child: ClipOval(
                                        child: Text(
                                      "${i.name![0]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.fontSize,
                                      ),
                                    )),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _showDialog(i);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  title: Text(
                                    i.name!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Role: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(i.role!.jobTitle!,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(" & Salary: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(i.role!.salary!.toString(),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Contact: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(i.contactNo!,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(" & Registration Date: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              DateToString(i.registrationDate!),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  focusColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  _showDialog(Employee i) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Are you sure?',
              ),
              content: Text(
                "You want to delete?",
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                TextButton(
                  child: Text(
                    'Yes',
                  ),
                  onPressed: () async {
                    if (i.id != user.id) {
                      await i.deleteEmployee();
                      await _loadData();
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, true);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    "Oops Can't delete",
                                  ),
                                ),
                                elevation: 20.0,
                              ));
                    }
                  },
                )
              ],
              elevation: 20.0,
            ));
  }

  @override
  initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    if (user.role!.id.toString() == "0") {
      await _getEmployees();
    } else
      await _getEmployees(roleId: user.role!.id!);
    _loading = false;
    setState(() {});
  }

  _getEmployees({int roleId = 0}) async {
    _employees.clear();
    var empList = await Employee().getEmployees(roleId: roleId);
    for (var i in empList) {
      User tempUser = new User();
      tempUser.setValues(i);
      _employees.add(tempUser);
    }
  }
}
