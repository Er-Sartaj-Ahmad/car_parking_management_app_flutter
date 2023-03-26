import 'dart:convert';
import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/roleModel.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageEmployees/manageEmployees.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageRolesAndSalaries/addRolesAndSalaries.dart';
import 'package:car_parking_system/properties.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageRolesAndSalaries extends StatefulWidget {
  late User user;

  ManageRolesAndSalaries({required this.user});

  @override
  State<ManageRolesAndSalaries> createState() =>
      _ManageRolesAndSalariesState(user: user);
}

class _ManageRolesAndSalariesState extends State<ManageRolesAndSalaries> {
  late User user;

  _ManageRolesAndSalariesState({required this.user});

  late bool _loading;
  List<RoleModel> _roleModel = [];
  double? _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddRolesAndSalaries();
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
            : _roleModel.isEmpty
                ? Text("No Records")
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var i in _roleModel)
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
                                  onTap: (){
                                    user.role!.id = i.id;
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ManageEmployees(user: user);
                                    })).then((value) => _loadData());
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        cicleAvatarColor[i.id! % 7],
                                    child: ClipOval(
                                        child: Text(
                                      "${i.jobTitle![0]}",
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
                                      onPressed: () async {
                                        if (i.totalEmployees == null)
                                          await _alertDialog(i);
                                      },
                                      icon: Icon(
                                        i.totalEmployees == null ? Icons.delete : Icons.edit,
                                        color: Colors.red,
                                      )),
                                  title: Text(
                                    i.jobTitle!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("Salary: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(i.salary.toString(),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(" & Registration Date: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(i.registrationDate!,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Total ${i.jobTitle}s: ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text(i.totalEmployees == null ? "0" : i.totalEmployees!.toString(),
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

  _alertDialog(var i) async {
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
                      await _deleteRole(i.id!);
                      await _loadData();
                      Navigator.pop(context, true);
                    })
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
    setState(() {
      _loading = true;
    });
    await _getRoles();
    _loading = false;
    setState(() {});
  }

  _getRoles() async {
    final response = await http.get(
        Uri.parse("http://localhost/Registration/SDA_Project/getRoles.php"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _roleModel.clear();
      for (Map i in data) {
        _roleModel.add(RoleModel.fromJson(i));
      }
      return;
    } else {
      return response.body.toString();
    }
  }

  _deleteRole(int id) async {
    final response = await http.post(
        Uri.parse("http://localhost/Registration/SDA_Project/deleteRole.php"),
        body: {'id': id.toString()});
    if (response.statusCode == 200) {
      return "deleted successfully";
    } else {
      return response.body.toString();
    }
  }
}
