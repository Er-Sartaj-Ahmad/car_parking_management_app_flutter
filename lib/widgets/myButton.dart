import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onPressed;

  const MyButton({
    required this.name,
    required this.onPressed,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: StadiumBorder(
        side: BorderSide(color: color)
      ),
      fillColor: color,
      onPressed: onPressed,
      highlightColor: Colors.black54,
      // child: Icon(icon,color: color,),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(name,style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}