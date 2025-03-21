import 'package:flutter/material.dart';

class Order extends StatelessWidget {

  const Order({ super.key });
  
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
            "Order!!!",
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