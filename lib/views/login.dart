import 'package:car_parking_system/models/user.dart';
import 'package:car_parking_system/views/adminPanelGUI/adminDashBoard.dart';
import 'package:car_parking_system/views/operatorPanelGUI/operatorDashBoard.dart';
import 'package:car_parking_system/widgets/myButton.dart';
import 'package:car_parking_system/widgets/myTextField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool ishide = true;
  User? _user = User();
  TextEditingController unameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? nameInputError;
  String? passwordInputError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Parking System"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height < 600
                ? 0
                : MediaQuery.of(context).size.height / 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width / 4
                      : MediaQuery.of(context).size.width / 10,
                  right: MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width / 4
                      : MediaQuery.of(context).size.width / 10,
                  top: 10,
                  bottom: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    offset: Offset(0.0, 20.0),
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.headline3!,
                    ),
                  ),
                  MyTextField(
                    controller: unameController,
                    errorText: nameInputError,
                    labelText: 'User Name',
                    hintText: 'Enter User Name',
                    icon: Icon(Icons.account_circle_outlined),
                    onChanged: (v) {
                      if (v != null) {
                        nameInputError = null;
                        setState(() {});
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 5),
                    child: TextField(
                      obscureText: ishide,
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          filled: false,
                          alignLabelWithHint: true,
                          errorText: passwordInputError,
                          suffix: IconButton(
                              onPressed: () {
                                //add Icon button at end of TextField
                                setState(() {
                                  ishide = !ishide;
                                });
                              },
                              icon: Icon(ishide == false
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      onChanged: (v) {
                        if (v != null) {
                          passwordInputError = null;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Text("forgot password?",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.button!.fontSize,
                          decoration: TextDecoration.underline)),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: MyButton(
                      onPressed: () async {
                        if (unameController.text != "" &&
                            passwordController.text != "") {
                          await _login();
                          return;
                        }
                        if (unameController.text == "") {
                          nameInputError = "User name can't be empty";
                        } else {
                          nameInputError = null;
                        }
                        if (passwordController.text == "") {
                          passwordInputError = "Password can't be empty";
                        } else {
                          passwordInputError = null;
                        }
                        setState(() {});
                      },
                      name: "Login",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _login() async {
    bool result =
        await _user!.login(unameController.text, passwordController.text);
    if (!result) {
      nameInputError = "Invalid user name or password";
      passwordInputError = "";
      setState(() {});
      return;
    } else {
      if (_user!.userName == unameController.text &&
          _user!.password == passwordController.text &&
          _user!.role!.jobTitle!.toUpperCase() == 'ADMIN') {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return AdminDashBoard(user: _user!);
        }), (route) => false);
      } else if (_user!.userName == unameController.text &&
          _user!.password == passwordController.text &&
          _user!.role!.jobTitle!.toUpperCase() == 'OPERATOR') {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return OperatorDashBoard(user: _user!);
        }), (route) => false);
      } else {
        nameInputError = "Invalid user name or password";
        passwordInputError = "";
        passwordController.clear();
        unameController.clear();
        setState(() {});
        return;
      }
    }
  }

  @override
  initState() {
    super.initState();
  }
}
