import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/models/message_model.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/services/auth_service.dart';
import 'package:new_assign/services/firestore_service.dart';

class ChatController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  final UserModel otherUser;
  ChatController(this.otherUser);

  final TextEditingController messageController = TextEditingController();
  final Rx<List<MessageModel>> _messages = Rx<List<MessageModel>>([]);
  List<MessageModel> get messages => _messages.value;

  late String _chatRoomId;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  void _initializeChat() async {
    final currentUserId = _authService.currentUser!.uid;
    _chatRoomId = await _firestoreService.createOrGetChatRoom(currentUserId, otherUser.id);
    _messages.bindStream(_firestoreService.getMessages(_chatRoomId));
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      final senderId = _authService.currentUser!.uid;
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple unique ID
        senderId: senderId,
        receiverId: otherUser.id,
        content: text,
        timestamp: DateTime.now(),
      );
      await _firestoreService.sendMessage(_chatRoomId, message);
      messageController.clear();
    }
  }
}
