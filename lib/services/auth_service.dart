import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getUserModel(String uid) async {
    try {
      return await _firestoreService.getUser(uid);
    } catch (e) {
      print('Error getting user model: $e');
      return null;
    }
  }

  // --- AUTHENTICATION ACTIONS ---

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Google sign in failed unexpectedly.');
      }

      // Check if it's a new user.
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        final newUserModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'No Name',
          photoUrl: user.photoURL ?? '',
          isOnline: true,
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
        );
        await _firestoreService.createUser(newUserModel);
        return newUserModel;
      } else {
        // If it's an existing user, fetch their profile.
        final userModel = await _firestoreService.getUser(user.uid);
        if (userModel == null) {
          // This is a recovery case in case the DB record is missing.
          throw Exception("Your user profile could not be found.");
        }
        return userModel;
      }
    } catch (e) {
      print("Google Sign-In Error: ${e.toString()}");
      throw Exception('Failed to Sign In with Google.');
    }
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Sign in failed unexpectedly.");
      }

      final userModel = await _firestoreService.getUser(user.uid);
      if (userModel == null) {
        throw Exception("Your user profile could not be found.");
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An unknown login error occurred.");
    }
  }

  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user == null) {
        throw Exception("User creation failed unexpectedly.");
      }

      await user.updateDisplayName(displayName);

      final userModel = UserModel(
        id: user.uid,
        email: email,
        displayName: displayName,
        photoUrl: '',
        isOnline: true,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUser(userModel);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "An unknown sign-up error occurred.");
    } catch (e) {
      await currentUser?.delete();
      print("Registration Error & Cleanup: ${e.toString()}");
      throw Exception("Couldn't create user profile. Please try again.");
    }
  }

  Future<void> signOut() async {
    try {
      if (currentUser != null) {
        await _firestoreService.updateUserOnlineStatus(currentUser!.uid, false);
      }
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Sign Out Error: ${e.toString()}");
    }
  }

  // --- ACCOUNT MANAGEMENT ---

  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to update password.");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to send reset email.");
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        await _firestoreService.deleteUser(user.uid);
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Failed to delete account.");
    }
  }
}
