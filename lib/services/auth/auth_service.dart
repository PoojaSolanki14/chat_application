import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get current user's email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Get current user's ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // ✅ Update Friend’s Username
  Future<void> updateFriendUsername(String friendUid, String newUsername) async {
    try {
      await _firestore.collection("Users").doc(friendUid).update({
        'username': newUsername,
      });
    } catch (e) {
      print("Error updating friend's username: $e");
      throw Exception("Failed to update username.");
    }
  }

  // Sign in with Email & Password
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Check if user document exists
      DocumentSnapshot userDoc =
      await _firestore.collection("Users").doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        await _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up with Email & Password
  // Sign up with Email & Password
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Extract username from email
      String username = email.split('@')[0];

      // Save user data in Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username, // ✅ Save username
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // Google Sign-In
  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await _firestore.collection("Users").doc(userCredential.user!.uid).get();

      if (!userDoc.exists || !(userDoc.data() as Map<String, dynamic>).containsKey('username')) {
        await _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'username': googleUser.displayName ?? googleUser.email.split('@')[0], // ✅ Save username
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing fields
      }

      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }


  // Sign out
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
