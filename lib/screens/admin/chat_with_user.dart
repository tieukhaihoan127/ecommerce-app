import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:ecommerce_app/providers/chat_provider.dart';
import 'package:ecommerce_app/helpers/image_upload.dart';

class ChatWithUserView extends StatefulWidget {
  final String? userId;
  final String? userName;
  final String? userAvatar;

  const ChatWithUserView({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
  });

  @override
  State<ChatWithUserView> createState() => _ChatWithUserViewState();
}

class _ChatWithUserViewState extends State<ChatWithUserView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  bool _isSendingImages = false;
  String? _previousUserId;

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  @override
  void didUpdateWidget(covariant ChatWithUserView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _setupChat();
    }
  }

  Future<void> _setupChat() async {
    _previousUserId = widget.userId;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.loadMessages(widget.userId!);
    chatProvider.connectSocket(widget.userId!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    Provider.of<ChatProvider>(context, listen: false).disconnectSocket();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend({List<String>? imageUrls}) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final content = _controller.text.trim();

    final newMessage = {
      "senderId": userProvider.user!.id, 
      "content": content,
      "images": imageUrls ?? [],
      "createdAt": DateTime.now().toIso8601String(),
      "avatar": userProvider.user!.imageUrl,
      "infoUser": userProvider.user!.fullName,
    };

    chatProvider.addLocalMessage(newMessage);
    chatProvider.sendMessage(userProvider.user!.id!, widget.userId!, content, imageUrls ?? []);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _pickAndSendImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) return;

    setState(() {
      _isSendingImages = true;
    });

    List<String> imageUrls = [];
    for (var file in pickedFiles) {
      final url = await ImageUpload().uploadImageToCloudinary(File(file.path));
      if (url != null) {
        imageUrls.add(url);
      }
    }

    setState(() {
      _isSendingImages = false;
    });

    _handleSend(imageUrls: imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final msg = provider.messages[index];
                  final isMe = msg["senderId"] != widget.userId; 
                  final avatarUrl = msg["avatar"] ?? "https://cdn-icons-png.flaticon.com/512/6596/6596121.png";
                  final userName = msg["infoUser"] ?? "Người dùng";

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment:
                                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              if ((msg["images"] as List?)?.isNotEmpty ?? false)
                                ...msg["images"].map<Widget>((imgUrl) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imgUrl,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              if ((msg["content"] as String?)?.isNotEmpty ?? false)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isMe ? Colors.blue : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    msg["content"] ?? "",
                                    style: TextStyle(
                                        color: isMe ? Colors.white : Colors.black),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isMe)
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _isSendingImages ? null : _pickAndSendImages,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Nhập tin nhắn...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSend(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
