import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/controllers/auth_controller.dart';

class RegisterController extends GetxController {
  final AuthController _authController = Get.find();

  final formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- UI State ---
  final RxBool isPasswordObscured = true.obs;

  // Expose the loading state from the AuthController directly.
  bool get isLoading => _authController.isLoading.value;

  @override
  void onClose() {
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // --- Actions ---
  void togglePasswordVisibility() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

  void register() {
    // Validate the form before proceeding.
    if (formKey.currentState?.validate() ?? false) {
      _authController.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
        displayNameController.text.trim(),
      );
    }
  }
}
