import 'package:chat_application/components/chat_bubble.dart';
import 'package:chat_application/services/auth/auth_service.dart';
import 'package:chat_application/services/chat/chat_service.dart';
import 'package:chat_application/pages/user_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class ChatPage extends StatefulWidget {
  String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  final ScrollController _scrollController = ScrollController();

  bool _showEmojiPicker = false;
  String _firstLetter = '';

  @override
  void initState() {
    super.initState();
    _loadReceiverData();
    Future.delayed(const Duration(milliseconds: 300), scrollDown);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ Fetch Receiver's Data
  Future<void> _loadReceiverData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_authService.getCurrentUser()!.uid)
          .collection('friends')
          .doc(widget.receiverID)
          .get();

      if (userDoc.exists) {
        setState(() {
          widget.receiverEmail = userDoc['username'] ?? widget.receiverEmail;

          // ✅ Extract first letter from username
          _firstLetter = widget.receiverEmail.isNotEmpty
              ? widget.receiverEmail[0].toUpperCase()
              : '';
        });
      }
    } catch (e) {
      print("Error loading receiver data: $e");
    }
  }

  // ✅ Scroll to the latest message
  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // ✅ Send a message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
      );
      _messageController.clear();
      scrollDown();
    }
  }

  // ✅ Emoji Picker
  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          setState(() {
            _messageController.text += emoji.emoji;
          });
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
          bgColor: Colors.white,
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          enableSkinTones: true,
          recentsLimit: 28,
        ),
      ),
    );
  }

  // ✅ Toggle Emoji Picker
  void toggleEmojiPicker() {
    FocusScope.of(context).unfocus(); // ✅ Close keyboard when opening emoji picker
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: true, // ✅ Fix for hiding issue
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputField(),
          if (_showEmojiPicker) _buildEmojiPicker(),
        ],
      ),
    );
  }

  // ✅ Build App Bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      foregroundColor: Colors.black,
      title: GestureDetector(
        onTap: () async {
          String? updatedUsername = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                userId: widget.receiverID,
              ),
            ),
          );

          if (updatedUsername != null) {
            setState(() {
              widget.receiverEmail = updatedUsername;
              _firstLetter = updatedUsername.isNotEmpty
                  ? updatedUsername[0].toUpperCase()
                  : '';
            });
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue.shade100,
              child: _firstLetter.isNotEmpty
                  ? Text(
                _firstLetter,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
                  : const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receiverEmail,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'clear_chat') {
              bool confirm = await _showConfirmationDialog();
              if (confirm) {
                await _chatService.clearChat(widget.receiverID);
              }
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear_chat',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Clear Chat'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ✅ Confirmation Dialog
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  // ✅ Build Message List
  Widget _buildMessageList() {
    String currentUserID = _authService.getCurrentUser()!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(currentUserID, widget.receiverID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            bool isCurrentUser = data['senderID'] == currentUserID;

            return ChatBubble(
              message: data['message'],
              isCurrentUser: isCurrentUser,
              timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
            );
          },
        );
      },
    );
  }

  // ✅ Input Field
  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
            onPressed: toggleEmojiPicker,
          ),
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) => sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
