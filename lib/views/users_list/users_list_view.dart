import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/controllers/user_list_controller.dart';
import 'package:new_assign/models/user_model.dart';

class UsersListView extends GetView<UsersListController> {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find People'),
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(child: _buildUsersList(context)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          // Use the fillColor from the theme's input decoration
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.filteredUsers.isEmpty) {
        return const Center(child: Text('No users found.'));
      }

      return ListView.builder(
        itemCount: controller.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = controller.filteredUsers[index];
          final status =
              controller.userRelationships[user.id] ?? UserRelationshipStatus.none;
          return ListTile(
            leading: CircleAvatar(
              // Use the theme's primary color
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Text(
                user.displayName.isNotEmpty
                    ? user.displayName[0].toUpperCase()
                    : '?',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            title: Text(user.displayName),
            subtitle: Text(user.email, style: Theme.of(context).textTheme.bodySmall),
            trailing: _buildActionButton(context, status, user.id),
          );
        },
      );
    });
  }

  Widget _buildActionButton(BuildContext context, UserRelationshipStatus status, String userId) {
    switch (status) {
      case UserRelationshipStatus.friendRequestSent:
        return OutlinedButton(
          onPressed: () => controller.cancelFriendRequest(userId),
          child: const Text('Cancel'),
        );
      case UserRelationshipStatus.friendRequestReceived:
        return ElevatedButton(
          onPressed: () => controller.acceptFriendRequest(userId),
          child: const Text('Accept'),
        );
      case UserRelationshipStatus.friends:
        return Chip(
          label: Text('Friends', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        );
      case UserRelationshipStatus.blocked:
        return Chip(
          label: Text('Blocked', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
        );
      case UserRelationshipStatus.none:
      default:
        return ElevatedButton.icon(
          onPressed: () => controller.sendFriendRequest(userId),
          icon: const Icon(Icons.person_add_alt_1, size: 16),
          label: const Text('Add'),
        );
    }
  }
}
