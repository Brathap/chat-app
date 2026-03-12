import 'package:get/get.dart';
import 'package:new_assign/controllers/home_controller.dart';
import 'package:new_assign/controllers/main_controller.dart';
import 'package:new_assign/controllers/profile_controller.dart';
import 'package:new_assign/controllers/user_list_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Using Get.put() instead of lazyPut to ensure controllers are always
    // available immediately for the PageView.
    Get.put<MainController>(MainController());
    Get.put<HomeController>(HomeController());
    Get.put<ProfileController>(ProfileController());
    Get.put<UsersListController>(UsersListController());
  }
}
