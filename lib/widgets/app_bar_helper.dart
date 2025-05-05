import 'package:ecommerce_app/screens/client/chat.dart';
import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarHelper extends StatefulWidget implements PreferredSizeWidget {

  final String userId;

  final String title;

  const AppBarHelper({super.key, required this.userId, required this.title});

  @override
  State<AppBarHelper> createState() => _AppBarCategoryHelperState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarCategoryHelperState extends State<AppBarHelper> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: widget.userId != "" ? IconButton.outlined(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userId: widget.userId,))); }, icon: Icon(Icons.mail, color: Colors.black,)) : Text("")
                
        ),
      ],
    );
  }
}
