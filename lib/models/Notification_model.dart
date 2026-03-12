import 'package:flutter/material.dart';

// 1. Renamed enum to avoid conflict with the class name.
enum NotificationType {
  friendRequest,
  friendRequestAccepted,
  friendRequestRejected,
  newMessage,
  friendRemoved
}

// Define possible actions as an enum for type safety
enum NotificationAction {
  acceptFriendRequest,
  rejectFriendRequest,
  viewMessage,
  viewProfile,
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  // 2. Updated type to use the new enum name.
  final NotificationType type;
  final Map<String, dynamic> data;
  final Map<String, dynamic> senderInfo; // e.g., {'id': 'user123', 'name': 'John Doe'}
  final bool isread;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.data = const {},
    this.senderInfo = const {},
    this.isread = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      // 3. Serialized enum to a string for Firestore compatibility.
      'type': type.name,
      'data': data,
      'senderInfo': senderInfo,
      'isread': isread,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  static NotificationModel fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      // 4. Correctly parsed enum from a string with a safe fallback.
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        // Provides a default value if the type from the map is invalid.
        orElse: () => NotificationType.friendRequest,
      ),
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      senderInfo: Map<String, dynamic>.from(map['senderInfo'] ?? {}),
      isread: map['isread'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    Map<String, dynamic>? data,
    Map<String, dynamic>? senderInfo,
    bool? isread,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      senderInfo: senderInfo ?? this.senderInfo,
      isread: isread ?? this.isread,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Returns a specific IconData based on the notification type.
  IconData get iconData {
    switch (type) {
      case NotificationType.friendRequest:
        return Icons.person_add;
      case NotificationType.friendRequestAccepted:
        return Icons.how_to_reg;
      case NotificationType.friendRequestRejected:
        return Icons.person_remove;
      case NotificationType.newMessage:
        return Icons.message;
      case NotificationType.friendRemoved:
        return Icons.person_off;
      default:
        return Icons.notifications;
    }
  }

  /// Provides a user-friendly, relative timestamp.
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Returns a list of available actions for this notification type.
  List<NotificationAction> get availableActions {
    switch (type) {
      case NotificationType.friendRequest:
        return [
          NotificationAction.acceptFriendRequest,
          NotificationAction.rejectFriendRequest
        ];
      case NotificationType.newMessage:
        return [NotificationAction.viewMessage];
      default:
        return []; // No actions for other types
    }
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, type: ${type.name}, title: "$title", isread: $isread, createdAt: $createdAt)';
  }
}
