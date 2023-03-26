import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String?) onChanged;
  final String? errorText;
  final String? labelText;
  final String? hintText;
  final Icon icon;
  final double? width;

  MyTextField(
      {required this.controller,
      required this.onChanged,
      required this.errorText,
      required this.hintText,
      required this.labelText,
      this.width = double.infinity,
      this.icon = const Icon(Icons.edit)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        width: width,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            labelText: labelText,
            hintText: hintText,
            prefixIcon: icon,
            filled: false,
            alignLabelWithHint: true,
            errorText: errorText,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
