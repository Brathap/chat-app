import 'package:cloud_firestore/cloud_firestore.dart';

// 1. Added a status enum for type safety and clarity.
enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
}

class FriendRequestModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String receiverId;
  final String receiverName;
  final String? receiverAvatarUrl;
  final FriendRequestStatus status;
  final String? message;
  final DateTime createdAt;
  final DateTime? respondedAt;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.receiverId,
    required this.receiverName,
    this.receiverAvatarUrl,
    this.status = FriendRequestStatus.pending,
    this.message,
    required this.createdAt,
    this.respondedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverAvatarUrl': receiverAvatarUrl,
      'status': status.name, // Stored as a string
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
    };
  }

  static FriendRequestModel fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderAvatarUrl: map['senderAvatarUrl'],
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverAvatarUrl: map['receiverAvatarUrl'],
      // Safely parse the enum from a string
      status: FriendRequestStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => FriendRequestStatus.pending,
      ),
      message: map['message'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      respondedAt: (map['respondedAt'] as Timestamp?)?.toDate(),
    );
  }
}
