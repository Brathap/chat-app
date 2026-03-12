import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/controllers/profile_controller.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/theme/app_theme.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Profile'),
        actions: [
          // --- THEME TOGGLE BUTTON ---
          IconButton(
            icon: Icon(
              Get.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
            ),
            onPressed: () {
              Get.changeThemeMode(
                Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          // ---------------------------
          Obx(
            () => TextButton(
              onPressed: controller.toggleEditing,
              child: Text(
                controller.isEditing.value ? 'Cancel' : 'Edit',
                style: TextStyle(
                  // Use theme-aware colors
                  color: controller.isEditing.value
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetX<ProfileController>(
        builder: (controller) {
          if (controller.currentUser.value == null) {
            return Center(
              child: CircularProgressIndicator(
                // Use theme-aware color
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          final user = controller.currentUser.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildProfileHeader(context, user),
                const SizedBox(height: 32),
                _buildInfoCard(),
                const SizedBox(height: 16),
                _buildActionsCard(context),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Chat App v1.0.0",
                  // Use theme-aware color
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Column(
      children: [
        Obx(() {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                // Use theme-aware color
                backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(26),
                child: ClipOval(
                  child: user.photoUrl.isNotEmpty
                      ? Image.network(user.photoUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildDefaultAvatar(context, user))
                      : _buildDefaultAvatar(context, user),
                ),
              ),
              if (controller.isEditing.value)
                Container(
                  decoration: BoxDecoration(
                    // Use theme-aware color
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.snackbar('Info', 'Photo Update Coming Soon');
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          );
        }),
        const SizedBox(height: 16),
        Text(
          user.displayName,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          // Use theme-aware color
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Use theme-aware colors
            color: user.isOnline
                ? AppTheme.successColor.withAlpha(26)
                : Theme.of(context).colorScheme.secondary.withAlpha(26),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    // Use theme-aware colors
                    color: user.isOnline
                        ? AppTheme.successColor
                        : Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(5),
                  )),
              const SizedBox(width: 8),
              Text(
                user.isOnline ? 'Online' : 'Offline',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    // Use theme-aware colors
                    color: user.isOnline
                        ? AppTheme.successColor
                        : Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          controller.getJoinDate(),
          // Use theme-aware color
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(Get.context!)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Obx(
              () => TextFormField(
                controller: controller.displayNameController,
                enabled: controller.isEditing.value,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.emailController,
              enabled: false,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  helperText: 'Email can not be changed'),
            ),
            Obx(() {
              if (controller.isEditing.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.updateProfile,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Save Changes"),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            // Use theme-aware color
            leading: Icon(Icons.security, color: Theme.of(context).colorScheme.primary),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar("Info", "Change Password Coming Soon");
            },
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            // Use theme-aware color
            leading:
                Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.error),
            title: const Text('Delete Account'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.deleteAccount,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            // Use theme-aware color
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.secondary),
            title: const Text('Sign Out'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: controller.signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, UserModel user) {
    return Center(
      child: Text(
        user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
        style: TextStyle(
          // Use theme-aware color for better contrast
          color: Theme.of(context).colorScheme.primary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
