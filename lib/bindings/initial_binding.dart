import 'package:get/get.dart';
import 'package:new_assign/controllers/auth_controller.dart';
import 'package:new_assign/services/auth_service.dart';
import 'package:new_assign/services/firestore_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<FirestoreService>(FirestoreService(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}
