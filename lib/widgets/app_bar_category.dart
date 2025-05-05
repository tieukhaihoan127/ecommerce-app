import 'package:ecommerce_app/screens/client/profile.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarCategoryHelper extends StatefulWidget implements PreferredSizeWidget {

  final String userId;

  const AppBarCategoryHelper({super.key, required this.userId});

  @override
  State<AppBarCategoryHelper> createState() => _AppBarCategoryHelperState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarCategoryHelperState extends State<AppBarCategoryHelper> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Categories',
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
          child: widget.userId != "" ? IconButton.outlined(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => Profile())); }, icon: Icon(Icons.mail, color: Colors.black,)) : TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Signin(),
                    ),
                  );
                },
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
        ),
      ],
    );
  }
}
