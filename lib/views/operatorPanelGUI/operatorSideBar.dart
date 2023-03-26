import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/services/userModel.dart';
import 'package:car_parking_system/views/operatorPanelGUI/manageMembership/manageMember.dart';
import 'package:car_parking_system/views/operatorPanelGUI/manageParking/addParking.dart';
import 'package:car_parking_system/views/operatorPanelGUI/manageParking/removeParking.dart';
import 'package:car_parking_system/views/login.dart';
import 'package:flutter/material.dart';

class OperatorSideBar extends StatelessWidget {
  late User user;
  OperatorSideBar({required this.user});
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
            leading: Icon(Icons.arrow_forward_outlined),
            title: Text('Enter Vehicle'),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddParking(user: user,fromSlot: false,floorId: 0,slotId: 0,);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back_outlined),
            title: Text('Exit Vehicle'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RemoveParking();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Membership'),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
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
}
