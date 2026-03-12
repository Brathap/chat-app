import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool emailSent = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void goBackToLogin() {
    if (Get.previousRoute.isNotEmpty) {
      Get.back();
    } else {
      Get.offAllNamed('/login');
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    }
    if (!GetUtils.isEmail(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  Future<void> sendPasswordResetEmail() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        await _authService.sendPasswordResetEmail(emailController.text.trim());
        if (!emailSent.value) {
          emailSent.value = true;
        } else {
          Get.snackbar(
            "Email Resent",
            "A new password reset link has been sent.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to send link. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void resendEmail() {
    sendPasswordResetEmail();
  }
}
