import 'package:get/get.dart';
import 'package:new_assign/controllers/user_list_controller.dart';

class UsersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersListController>(() => UsersListController());
  }
}
