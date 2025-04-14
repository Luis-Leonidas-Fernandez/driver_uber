import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  
  const Button({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.indigo)
            ),              
            child:  const Text('Tengo una Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
    );
  }
}