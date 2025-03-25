import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/bottom_nav.dart';
import 'package:ecommerce_app/screens/client/change_user_information.dart';
import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:ecommerce_app/screens/client/signup.dart';
import 'package:ecommerce_app/screens/client/submit_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AddressProvider())
    ],
    child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: Signin(),
    );
  }
}



