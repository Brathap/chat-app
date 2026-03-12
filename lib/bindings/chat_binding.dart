import 'package:get/get.dart';
import 'package:new_assign/controllers/chat_controller.dart';
import 'package:new_assign/models/user_model.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final UserModel otherUser = Get.arguments as UserModel;
    Get.lazyPut<ChatController>(() => ChatController(otherUser));
  }
}
