import 'package:ecommerce_app/providers/address_provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:ecommerce_app/providers/coupon_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/providers/review_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/client/bottom_nav.dart';
import 'package:ecommerce_app/screens/client/cart.dart';
import 'package:ecommerce_app/screens/client/category.dart';
import 'package:ecommerce_app/screens/client/change_user_information.dart';
import 'package:ecommerce_app/screens/client/coupon_page.dart';
import 'package:ecommerce_app/screens/client/home.dart';
import 'package:ecommerce_app/screens/client/order_history.dart';
import 'package:ecommerce_app/screens/client/order_tracking.dart';
import 'package:ecommerce_app/screens/client/payment_method.dart';
import 'package:ecommerce_app/screens/client/product_detail_page.dart';
import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:ecommerce_app/screens/client/signup.dart';
import 'package:ecommerce_app/screens/client/submit_otp.dart';
import 'package:ecommerce_app/screens/client/test.dart';
import 'package:ecommerce_app/widgets/carousel.dart';
import 'package:ecommerce_app/widgets/cart_item_card.dart';
import 'package:ecommerce_app/widgets/coupon_card.dart';
import 'package:ecommerce_app/widgets/order_info_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AddressProvider()),
      ChangeNotifierProvider(create: (context) => ProductProvider()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
      ChangeNotifierProvider(create: (context) => CouponProvider()),
      ChangeNotifierProvider(create: (context) => ReviewProvider()),
    ],
    child: MyApp(),
    )
  );
}

Future<String> getSessionId() async {
  final prefs = await SharedPreferences.getInstance();
  String? sessionId = prefs.getString('session_id');
  if (sessionId == null) {
    sessionId = const Uuid().v4(); 
    await prefs.setString('session_id', sessionId);
  }
  return sessionId;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getSessionId();
    Provider.of<UserProvider>(context, listen: false).getUserById();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: BottomNavBar()
    );
  }
}



