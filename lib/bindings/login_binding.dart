import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // The AuthController is already initialized in InitialBinding.
    // No need to re-create it here.
  }
}
