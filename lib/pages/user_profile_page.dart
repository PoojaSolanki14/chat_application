import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  String _firstLetter = '';
  bool _isEditingUsername = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _loadUserData();
  }

  // ✅ Load User Data
  Future<void> _loadUserData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('friends')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _usernameController.text = userDoc.data()?['username'] ?? '';
          _emailController.text = userDoc.data()?['email'] ?? '';

          // ✅ First Letter of Username
          _firstLetter = _usernameController.text.isNotEmpty
              ? _usernameController.text[0].toUpperCase()
              : '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading user data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Update Username
  Future<void> _updateUsername() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('friends')
          .doc(widget.userId)
          .update({
        'username': _usernameController.text.trim(),
      });

      setState(() {
        _firstLetter = _usernameController.text[0].toUpperCase();
        _isEditingUsername = false; // ✅ Close editing mode
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating username: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // ✅ Light background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: _updateUsername,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Profile Picture with First Letter or Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: _firstLetter.isNotEmpty
                  ? Text(
                _firstLetter,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Editable Username Field with Edit Button
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      enabled: _isEditingUsername,
                      onChanged: (value) {
                        setState(() {
                          _firstLetter = value.isNotEmpty
                              ? value[0].toUpperCase()
                              : '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingUsername ? Icons.check : Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditingUsername = !_isEditingUsername;
                      if (!_isEditingUsername) _updateUsername(); // ✅ Update on Confirm
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ✅ Read-Only Email Field
            Card(
              elevation: 2,
              shadowColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Save Changes Button
            ElevatedButton(
              onPressed: _updateUsername,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
