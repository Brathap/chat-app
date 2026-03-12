import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/controllers/auth_controller.dart';
import 'package:new_assign/controllers/home_controller.dart';
import 'package:new_assign/controllers/main_controller.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/routes/app_routes.dart';
import 'package:new_assign/theme/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final MainController mainController = Get.find<MainController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_pin),
            onPressed: () => mainController.changeTabIndex(4), // Switches to profile tab
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context), // Added search bar
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Now uses the filteredUsers list
              if (controller.filteredUsers.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              final currentUserId = authController.userModel?.id;

              // The body now correctly displays the filtered list of users.
              return ListView.builder(
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.filteredUsers[index];

                  // Don't show the current user in the chat list
                  if (user.id == currentUserId) {
                    return const SizedBox.shrink();
                  }

                  return _buildUserTile(context, user);
                },
              ); 
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mainController.changeTabIndex(2), // Switches to user finding tab
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  // Widget for the search input field
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search chats...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          // Use the fillColor from the theme's input decoration for consistency
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  // This widget is now correctly part of the HomeView.
  Widget _buildUserTile(BuildContext context, UserModel user) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 25,
            // Use withAlpha for better performance and predictability
            backgroundColor: theme.colorScheme.primary.withAlpha(26), // ~10% opacity
            child: Text(
              user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
              // Use the primary color from the theme's colorScheme
              style: TextStyle(color: theme.colorScheme.primary, fontSize: 20),
            ),
          ),
          if (user.isOnline)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                // This color is a specific brand color, keeping it direct is okay
                color: AppTheme.successColor,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 2), // Use surface color for border
              ),
            ),
        ],
      ),
      title: Text(user.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        user.isOnline ? 'Online' : 'Last seen recently',
        // Use theme-aware colors for subtitle
        style: TextStyle(
            color: user.isOnline
                ? AppTheme.successColor
                : theme.colorScheme.secondary),
      ),
      onTap: () {
        Get.toNamed(AppRoutes.chat, arguments: user);
      },
    );
  }
}
