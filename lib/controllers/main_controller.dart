import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // 1. Added reactive variable for the tab index.
  final RxInt tabIndex = 0.obs;

  // 2. Added the PageController.
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // 3. Added the method to handle page changes from the PageView.
  void onPageChanged(int index) {
    tabIndex.value = index;
  }

  // 4. Added the method to handle taps on the BottomNavigationBar.
  void changeTabIndex(int index) {
    tabIndex.value = index;
    pageController.jumpToPage(index);
  }

  // 5. Added the missing method for the unread count.
  // This can be connected to a data source later.
  int getUnreadCount() {
    // Placeholder logic
    return 0;
  }
}
