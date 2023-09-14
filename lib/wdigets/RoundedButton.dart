import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final VoidCallback onpressed;
  final Color color;
  final String text;
  Widget? child;

  RoundedButton({required this.color,required this.onpressed,required this.text,this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: ElevatedButton(
          onPressed: onpressed,
          style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(200.0, 42.0)),
          backgroundColor: MaterialStateProperty.all(color)
          ),

          child: child ??=Text(
            text,
          ) ,
        ),
      ),
    );
  }
}
