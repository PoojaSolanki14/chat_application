import 'package:chat_application/components/user_tile.dart';
import 'package:chat_application/services/auth/auth_service.dart';
import 'package:chat_application/components/my_drawer.dart';
import 'package:chat_application/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'add_friend_page.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // ✅ Invite Friend Link
  void _sendInvite() {
    String inviteMessage =
        "Hey! Join me on this awesome chat app: https://yourapp.com/invite";
    Share.share(inviteMessage);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail =
        _authService.getCurrentUserEmail() ?? "Unknown User";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(currentUserEmail),
      drawer: MyDrawer(currentUserEmail: currentUserEmail),
      body: _buildUserList(),

      // ✅ Floating Action Button to Add Friend
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFriendPage(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ✅ Modern App Bar
  AppBar _buildAppBar(String currentUserEmail) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Home",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Logged in as: $currentUserEmail",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: _sendInvite,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.person_add, color: Colors.white, size: 18),
                SizedBox(width: 5),
                Text(
                  "Invite",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Build Friend List
  // ✅ Build Friend List
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getFriendList(), // ✅ Fixed collection name
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error loading friends: ${snapshot.error}");
          return _buildErrorState();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        print("✅ Friend list fetched successfully");

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(snapshot.data![index], context);
          },
        );
      },
    );
  }


  // ✅ Build Friend Tile
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    String username = userData["username"] ?? "Unknown User";
    String uid = userData["uid"] ?? "";

    // ✅ Extract first letter of username
    String firstLetter = username.isNotEmpty ? username[0].toUpperCase() : "?";

    if (uid.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              firstLetter,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          title: Text(
            username,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                bool confirm = await _showConfirmationDialog(context, username);
                if (confirm) {
                  try {
                    await _chatService.deleteFriend(uid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Friend deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting friend: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: username,
                  receiverID: uid,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String username) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Friend'),
          content: Text('Are you sure you want to delete $username?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    ) ?? false;
  }



  // ✅ Empty State
  Widget _buildEmptyState() {
    return const Center(
      child: Text("No friends available"),
    );
  }

  // ✅ Loading State
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  // ✅ Error State
  Widget _buildErrorState() {
    return const Center(
      child: Text("Error loading friends"),
    );
  }
}
