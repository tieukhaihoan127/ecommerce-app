import 'package:flutter/material.dart';

class Cart extends StatelessWidget {

  const Cart({ super.key });
  
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
            "Cart!!!",
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