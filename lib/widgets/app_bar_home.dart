import 'package:flutter/material.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {

  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [

          Builder(
            builder: (context) => IconButton.outlined(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); 
              },
            ),
          ),

          SizedBox(width: 5),

          CircleAvatar(
            backgroundImage: NetworkImage('https://res.cloudinary.com/dwdhkwu0r/image/upload/v1742743354/public/lafrmfp3o9jdgbl4csnb.jpg'), // Thay link ảnh avatar
            radius: 20,
          ),

          SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "Agasya!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),

          Spacer(),

          Stack(
            children: [
              IconButton.outlined(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}