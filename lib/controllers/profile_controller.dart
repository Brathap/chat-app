import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/controllers/auth_controller.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/services/firestore_service.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxBool _isLoading = false.obs;
  final RxBool _isEditing = false.obs;
  Worker? _userModelListener;

  // --- GETTERS ---
  // Directly expose the user model stream from the AuthController.
  Rx<UserModel?> get currentUser => _authController.userModelStream;
  RxBool get isLoading => _isLoading;
  RxBool get isEditing => _isEditing;

  // --- LIFECYCLE ---
  @override
  void onInit() {
    super.onInit();
    // Set up a listener to update the text controllers whenever the user model changes.
    _userModelListener = ever(currentUser, (UserModel? user) {
      if (user != null) {
        displayNameController.text = user.displayName;
        emailController.text = user.email;
      }
    });

    // Initialize text controllers with the current value if it already exists.
    if (currentUser.value != null) {
      displayNameController.text = currentUser.value!.displayName;
      emailController.text = currentUser.value!.email;
    }
  }

  @override
  void onClose() {
    _userModelListener?.dispose();
    displayNameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // --- ACTIONS ---
  void toggleEditing() {
    _isEditing.value = !_isEditing.value;
    // Reset text fields if editing is cancelled.
    if (!_isEditing.value && currentUser.value != null) {
      displayNameController.text = currentUser.value!.displayName;
      emailController.text = currentUser.value!.email;
    }
  }

  Future<void> updateProfile() async {
    if (currentUser.value == null) return;
    _isLoading.value = true;
    try {
      final updatedUser = currentUser.value!.copyWith(
        displayName: displayNameController.text,
      );
      await _firestoreService.updateUser(updatedUser);
      // The stream in AuthController will be updated by the service,
      // which will automatically reflect here.
      _isEditing.value = false;
      Get.snackbar('Success', "Profile updated successfully");
    } catch (e) {
      Get.snackbar('Error', "Failed to update profile");
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async => _authController.signOut();
  Future<void> deleteAccount() async => _authController.deleteAccount();

  String getJoinDate() {
    if (currentUser.value == null) return "";
    final date = currentUser.value!.createdAt;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return 'Joined ${months[date.month - 1]} ${date.year}';
  }
}
