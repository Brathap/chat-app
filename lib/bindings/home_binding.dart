import 'package:get/get.dart';
import 'package:new_assign/controllers/home_controller.dart';
import 'package:new_assign/controllers/profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
