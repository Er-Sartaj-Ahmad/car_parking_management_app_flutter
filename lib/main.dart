import 'package:car_parking_system/views/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Parking System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
      // routes: <String,WidgetBuilder>{
      //   '/views/operatorPanel': (BuildContext context)=> new OperatorPanel(),
      //   '/views/adminPanel': (BuildContext context)=> new AdminPanel(),
      //   '/views/forgotPassword': (BuildContext context)=> new ForgotPassword(),
      //   '/views/loginPanel': (BuildContext context)=> new Login(),
      // },
    );
  }
}