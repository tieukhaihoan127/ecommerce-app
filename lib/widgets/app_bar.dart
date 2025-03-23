import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AppBarHelper extends StatelessWidget {

  final String header;
  const AppBarHelper({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
  
}