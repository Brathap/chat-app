import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/theme/app_theme.dart';
import '../../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: controller.goBackToLogin,
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Forgot Password",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            "Please enter your email address. You will receive a link to create a new password via email.",
                            // Use the color from the theme directly
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Center(
                            child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            color: AppTheme.primaryColor,
                            size: 50,
                          ),
                        )),
                        const SizedBox(
                          height: 40,
                        ),
                        Obx(() {
                          if (controller.emailSent.value) {
                            return _buildEmailSentContent(context, controller);
                          } else {
                            return _buildEmailForm(context, controller);
                          }
                        })
                      ],
                    )))));
  }

  Widget _buildEmailForm(
      BuildContext context, ForgotPasswordController controller) {
    return Column(children: [
      TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: "Email Address",
          prefixIcon: Icon(Icons.email_outlined),
          hintText: "Enter your email address",
        ),
        validator: controller.validateEmail,
      ),
      const SizedBox(
        height: 32,
      ),
      Obx(
        () => SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  controller.isLoading.value ? null : () => controller.sendPasswordResetEmail(),
              icon: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(controller.isLoading.value ? "Sending..." : "Send Reset Link"),
            )),
      ),
      const SizedBox(height: 32),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Remember your password?",
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: controller.goBackToLogin,
            child: Text('Sign In',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    )),
          )
        ], 
      ),
    ]);
  }

  Widget _buildEmailSentContent(
      BuildContext context, ForgotPasswordController controller) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.successColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.mark_email_read_rounded,
              color: AppTheme.successColor,
              size: 50,
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Email Sent",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: AppTheme.successColor)),
            const SizedBox(
              height: 16,
            ),
            Text(
              "We have sent a password reset link to:",
              // Use the color from the theme directly
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              controller.emailController.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Please check your email and follow the instructions to reset your password.",
              // Use the color from the theme directly
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 32,
      ),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: controller.resendEmail,
          icon: const Icon(Icons.email_outlined),
          label: const Text("Resend Email"),
        ),
      ),
      const SizedBox(
        height: 16,
      ),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: controller.goBackToLogin,
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back to Sign In"),
        ),
      ),
      const SizedBox(
        height: 24,
      ),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Use the secondary color from the theme's colorScheme
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              // Use the secondary color from the theme's colorScheme
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Didn't receive the email? Check your spam folder or try resending.",
                // Use the color from the theme directly
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          ],
        ),
      )
    ]);
  }
}
