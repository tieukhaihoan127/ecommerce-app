import 'package:flutter/material.dart';

class Guest extends StatelessWidget {

  const Guest({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 40
        ),
        child: Center(
          child: Text(
            "Please sign in!!!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  

}