import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_assign/models/friend_request_model.dart';
import 'package:new_assign/models/friends_model.dart';
import 'package:new_assign/models/message_model.dart';
import 'package:new_assign/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Methods ---
  Future<void> createUser(UserModel user) =>
      _db.collection('users').doc(user.id).set(user.toMap());

  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  Stream<List<UserModel>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }

  Future<void> updateUser(UserModel user) =>
      _db.collection('users').doc(user.id).update(user.toMap());

  Future<void> deleteUser(String userId) =>
      _db.collection('users').doc(userId).delete();

  // --- This was the missing method ---
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) {
    return _db.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  // --- Chat & Message Methods ---
  Future<String> createOrGetChatRoom(String userId1, String userId2) async {
    List<String> userIds = [userId1, userId2]..sort();
    String chatRoomId = userIds.join('_');
    final docRef = _db.collection('chat_rooms').doc(chatRoomId);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.set({
        'id': chatRoomId,
        'userIds': userIds,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
    }
    return chatRoomId;
  }

  Future<void> sendMessage(String chatRoomId, MessageModel message) {
    return _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  // --- Friend & Relationship Methods ---

  Stream<List<FriendRequestModel>> getSentFriendRequestsStream(String userId) {
    return _db
        .collection('friend_requests')
        .where('senderId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FriendRequestModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<FriendRequestModel>> getReceivedFriendRequestsStream(
      String userId) {
    return _db
        .collection('friend_requests')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FriendRequestModel.fromMap(doc.data()))
            .toList());
  }

  Stream<List<FriendsModel>> getFriendsStream(String userId) {
    return _db
        .collection('friends')
        .where('userIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FriendsModel.fromMap(doc.data())).toList());
  }

  Future<void> sendFriendRequest(FriendRequestModel request) {
    return _db.collection('friend_requests').doc(request.id).set(request.toMap());
  }

  Future<void> deleteFriendRequest(String requestId) {
    return _db.collection('friend_requests').doc(requestId).delete();
  }

  Future<void> acceptFriendRequest(FriendRequestModel request) async {
    final newFriend = FriendsModel(
      id: request.id,
      user1Id: request.senderId,
      user2Id: request.receiverId,
      createdAt: DateTime.now(),
    );
    WriteBatch batch = _db.batch();
    batch.set(_db.collection('friends').doc(newFriend.id), newFriend.toMap());
    batch.delete(_db.collection('friend_requests').doc(request.id));
    await batch.commit();
  }
}
