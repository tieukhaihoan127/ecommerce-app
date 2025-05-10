import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/admin/main_screen.dart';
import 'package:ecommerce_app/screens/client/chat.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarCategoryHelper extends StatefulWidget implements PreferredSizeWidget {

  const AppBarCategoryHelper({super.key});

  @override
  State<AppBarCategoryHelper> createState() => _AppBarCategoryHelperState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarCategoryHelperState extends State<AppBarCategoryHelper> {

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

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
          child: userProvider.user?.id != null ? userProvider.user?.isAdmin == true ? IconButton.outlined(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen())); }, icon: Icon(Icons.admin_panel_settings, color: Colors.black,)) : IconButton.outlined(onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userId: userProvider.user?.id ?? ""))); }, icon: Icon(Icons.mail, color: Colors.black,)) : TextButton(
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
