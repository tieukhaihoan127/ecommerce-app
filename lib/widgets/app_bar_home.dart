import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/screens/admin/main_screen.dart';
import 'package:ecommerce_app/screens/client/chat.dart';
import 'package:ecommerce_app/screens/client/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarHome extends StatefulWidget implements PreferredSizeWidget {
  const AppBarHome({super.key});

  @override
  State<AppBarHome> createState() => _AppBarHomeState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarHomeState extends State<AppBarHome> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          if (userProvider.user?.id != null) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(
                userProvider.user?.imageUrl ??
                    'https://cdn-icons-png.flaticon.com/512/6596/6596121.png',
              ),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '${userProvider.user?.fullName ?? ''}!',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: 100,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://res.cloudinary.com/dwdhkwu0r/image/upload/v1747374500/public/mz23blln8lktkkb3hex8.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: userProvider.user?.id != null
              ? (userProvider.user?.isAdmin == true
                  ? IconButton.outlined(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  MainScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.black,
                      ),
                    )
                  : IconButton.outlined(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(userId: userProvider.user?.id ?? '')),
                        );
                      },
                      icon: const Icon(
                        Icons.mail,
                        color: Colors.black,
                      ),
                    ))
              : TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Signin(),
                      ),
                    );
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
