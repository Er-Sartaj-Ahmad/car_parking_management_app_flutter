import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageEmployees/manageEmployees.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageVehicleTypesAndCharges/manageVehicleTypesAndCharges.dart';
import 'package:car_parking_system/views/login.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageRolesAndSalaries/manageRolesAndSalaries.dart';
import 'package:car_parking_system/views/adminPanelGUI/manageFloorsAndSlots/manageFloors.dart';
import 'package:flutter/material.dart';

import '../operatorPanelGUI/manageMembership/manageMember.dart';

class AdminSideBar extends StatelessWidget {
  late User user;

  AdminSideBar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPictureSize: Size.square(70.0),
            accountName: Text('${user.name}'),
            accountEmail: Text('${user.name}@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                  child: Text(
                "${user.name![0].toUpperCase()}",
                style: Theme.of(context).textTheme.headline4,
              )),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('images/sidebarbg.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Floors and Slots'),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ManageFloors(user: user);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Roles and Salaries'),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ManageRolesAndSalaries(user: user);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Employees'),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ManageEmployees(
                  user: user,
                );
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Vehicle Types and Charges'),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ManageVehicleTypesAndCharges();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Membership'),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ManageMembers(user: user);
              }));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Log Out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return Login();
              }), (route) => false);
            },
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    user.role!.id = 0;
  }

}
