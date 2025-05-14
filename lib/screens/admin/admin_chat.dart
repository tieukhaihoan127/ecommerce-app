import 'package:ecommerce_app/screens/admin/chat_with_user.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  String? selectedUserId;
  String? selectedUserName;
  String? selectedUserAvatar;

  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false).fetchChatUsers();
  }

  void _selectUser(String userId, String fullName, String avatarUrl) async {
    setState(() {
      selectedUserId = userId;
      selectedUserName = fullName;
      selectedUserAvatar = avatarUrl;
    });

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.loadMessages(userId);
    chatProvider.connectSocket(userId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final users = chatProvider.chatUsers;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Chat")),
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['imageUrl'] ??
                        'https://cdn-icons-png.flaticon.com/512/6596/6596121.png'),
                  ),
                  title: Text(user['fullName']),
                  onTap: () {
                    _selectUser(user['_id'], user['fullName'], user['imageUrl']);
                  },
                  selected: user['_id'] == selectedUserId,
                );
              },
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: selectedUserId == null
                ? const Center(child: Text("Chọn người dùng để bắt đầu chat"))
                : ChatWithUserView(
                    userId: selectedUserId!,
                    userName: selectedUserName ?? "",
                    userAvatar: selectedUserAvatar ?? "",
                  ),
          )
        ],
      ),
    );
  }
}
