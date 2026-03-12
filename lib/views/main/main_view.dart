import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/controllers/main_controller.dart';
import 'package:new_assign/views/home/home_view.dart';
import 'package:new_assign/views/profile/profile_view.dart';
import 'package:new_assign/views/users_list/users_list_view.dart';

// --- Placeholder Widgets for missing views ---
class FriendsView extends StatelessWidget {
  const FriendsView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Friends Screen'));
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Notifications Screen'));
}
// --------------------------------------------

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: const [
          HomeView(),
          FriendsView(),
          // 1. Replaced the placeholder with the actual UsersListView.
          UsersListView(),
          NotificationsView(),
          ProfileView(),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            // Use theme-aware colors from the context
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 8,
            items: [
              BottomNavigationBarItem(
                icon: _buildIconWithBadge(
                  Icons.chat_bubble_outline,
                  controller.getUnreadCount(),
                ),
                activeIcon: _buildIconWithBadge(
                  Icons.chat_bubble,
                  controller.getUnreadCount(),
                ),
                label: 'Chats',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Friends',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_search_outlined),
                activeIcon: Icon(Icons.person_search),
                label: 'Find',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Activity',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          )),
    );
  }

  Widget _buildIconWithBadge(IconData icon, int count) {
    return Stack(
      clipBehavior: Clip.none, // Allow badge to overflow icon bounds
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
