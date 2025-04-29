import 'package:chat_application/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Send Invite
  Future<void> sendInvite() async {
    try {
      await Share.share(
          "Hey! Join me on this awesome chat app: https://yourapp.com/invite");
    } catch (e) {
      print("Error sharing invite: $e");
    }
  }

  // ✅ Get current user's ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // ✅ Get current user's email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // ✅ Check if a user exists by email
  Future<bool> checkUserExists(String email) async {
    try {
      var querySnapshot = await _firestore
          .collection('Users') // ✅ Fixed collection name
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  // ✅ Delete Friend
  Future<void> deleteFriend(String friendId) async {
    String? currentUserId = getCurrentUserId();

    if (currentUserId == null) throw Exception("No user is logged in.");

    try {
      await _firestore
          .collection('Users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendId)
          .delete();

      print("✅ Friend deleted successfully");
    } catch (e) {
      print("❌ Error deleting friend: $e");
      throw Exception(e.toString());
    }
  }

  // ✅ Clear Chat
  Future<void> clearChat(String receiverId) async {
    String? currentUserId = getCurrentUserId();

    if (currentUserId == null) {
      throw Exception("No user is logged in.");
    }

    String chatRoomID = generateChatRoomId(currentUserId, receiverId);

    try {
      var batch = _firestore.batch();

      var messages = await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .get();

      for (var message in messages.docs) {
        batch.delete(message.reference);
      }

      await batch.commit();

      print("✅ Chat cleared successfully");
    } catch (e) {
      print("❌ Error clearing chat: $e");
      throw Exception(e.toString());
    }
  }

  // ✅ Add Friend
  Future<void> addFriend(String email) async {
    try {
      email = email.trim().toLowerCase();

      String? currentUserEmail = _auth.currentUser?.email;
      if (currentUserEmail == null) throw Exception("User not logged in");

      // ✅ Prevent adding yourself
      if (email == currentUserEmail) {
        throw Exception("You cannot add yourself as a friend.");
      }

      var userQuery = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('User not found');
      }

      var friendId = userQuery.docs.first.id;
      var friendData = userQuery.docs.first.data();

      String currentUserId = _auth.currentUser!.uid;

      // ✅ Fetch current user's data
      DocumentSnapshot currentUserDoc =
      await _firestore.collection('Users').doc(currentUserId).get();
      var currentUserData = currentUserDoc.data() as Map<String, dynamic>;

      // ✅ Check if already friends
      var friendDoc = await _firestore
          .collection('Users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendId)
          .get();

      if (friendDoc.exists) {
        throw Exception("You are already friends.");
      }

      // ✅ Store in both users' friend lists
      WriteBatch batch = _firestore.batch();

      // ✅ Add friend to current user's friend list
      batch.set(
        _firestore.collection('Users').doc(currentUserId).collection('friends').doc(friendId),
        {
          'username': friendData.containsKey('username') ? friendData['username'] : 'Unknown User',
          'email': friendData.containsKey('email') ? friendData['email'] : '',
          'addedAt': FieldValue.serverTimestamp(),
        },
      );

      // ✅ Add current user to friend's friend list
      batch.set(
        _firestore.collection('Users').doc(friendId).collection('friends').doc(currentUserId),
        {
          'username': currentUserData.containsKey('username') ? currentUserData['username'] : 'Unknown User',
          'email': currentUserData.containsKey('email') ? currentUserData['email'] : '',
          'addedAt': FieldValue.serverTimestamp(),
        },
      );

      await batch.commit();

      print("✅ Friendship added for both users successfully");
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  // ✅ Get Friend List
  Stream<List<Map<String, dynamic>>> getFriendList() {
    final String? currentUserId = getCurrentUserId();

    if (currentUserId == null) {
      throw Exception("No user is logged in.");
    }

    return _firestore
        .collection('Users') // ✅ Fixed collection name
        .doc(currentUserId)
        .collection('friends')
        .snapshots()
        .map((snapshot) {
      print("Friend list size: ${snapshot.docs.length}");

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return {
          'uid': doc.id,
          'email': data.containsKey('email') ? data['email'] : '',
          'username': data.containsKey('username') ? data['username'] : 'Unknown User',
        };
      }).toList();
    });
  }

  // ✅ Send Message
  Future<void> sendMessage(String receiverId, String message) async {
    final String? currentUserId = getCurrentUserId();
    if (currentUserId == null) {
      throw Exception("No user is logged in.");
    }

    final senderDoc = await _firestore.collection("Users").doc(currentUserId).get();
    Map<String, dynamic>? senderData = senderDoc.data();

    String senderUsername = senderData != null && senderData.containsKey('username')
        ? senderData['username']
        : 'Unknown User';

    final String currentUserEmail = _auth.currentUser?.email ?? "Unknown";
    final Timestamp timestamp = Timestamp.now();

    if (message.trim().isEmpty) {
      throw Exception("Message cannot be empty.");
    }

    Message newMessage = Message(
      senderID: currentUserId,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );

    await _firestore
        .collection("chat_rooms")
        .doc(generateChatRoomId(currentUserId, receiverId))
        .collection("messages")
        .add(newMessage.toMap());
  }

  // ✅ Generate Chat Room ID
  String generateChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  // ✅ Get Messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    String chatRoomID = generateChatRoomId(userID, otherUserID);

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // ✅ Verify if user exists
  Future<bool> verifyUserExists(String userId) async {
    DocumentSnapshot userDoc =
    await _firestore.collection("Users").doc(userId).get();
    return userDoc.exists;
  }
}
