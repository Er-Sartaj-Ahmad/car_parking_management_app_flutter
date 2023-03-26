import 'package:flutter/material.dart';

const Map<int, Color> cicleAvatarColor = {
  0: Color.fromARGB(255, 217, 79, 15),
  1: Color.fromARGB(255, 59, 95, 238),
  2: Color.fromARGB(255, 229, 168, 20),
  3: Color.fromARGB(255, 75, 218, 18),
  4: Color.fromARGB(255, 120, 18, 231),
  5: Color.fromARGB(255, 220, 196, 32),
  6: Color.fromARGB(255, 161, 64, 153),
  7: Color.fromARGB(255, 48, 227, 213),
};

DateToString(DateTime dateTime){
  return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
}