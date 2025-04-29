import 'package:chat_application/components/my_button.dart';
import 'package:chat_application/components/my_textfield.dart';
import 'package:chat_application/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final ChatService _chatService = ChatService();

  bool _isLoading = false;

  // ✅ Add Friend Method
  void _addFriend() async {
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();

    if (email.isEmpty || username.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _chatService.addFriend(email);

      // ✅ Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Friend added successfully!")),
      );

      // ✅ Clear fields and close page
      _emailController.clear();
      _usernameController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding friend: $e")),
      );
    }
    finally {
      setState(() => _isLoading = false);
    }
  }


  // ✅ Show Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Friend"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add a new friend",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Email TextField
            MyTextfield(
              hintText: "Friend's Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),

            // ✅ Username TextField
            MyTextfield(
              hintText: "Friend's Username",
              obscureText: false,
              controller: _usernameController,
            ),
            const SizedBox(height: 20),

            // ✅ Add Friend Button
            _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
                : MyButton(
              text: "Add Friend",
              onTap: _addFriend,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
