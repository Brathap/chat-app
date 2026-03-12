class FriendsModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final bool isBlocked;
  final String? blockedBy;

  FriendsModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.isBlocked = false,
    this.blockedBy,
  });

  Map<String, dynamic> toMap() {
    // 1. Fixed the broken toMap method.
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isBlocked': isBlocked,
      'blockedBy': blockedBy,
    };
  }

  static FriendsModel fromMap(Map<String, dynamic> map) {
    // 2. Made fromMap safe against null data from Firestore.
    return FriendsModel(
      id: map['id'] ?? '',
      user1Id: map['user1Id'] ?? '',
      user2Id: map['user2Id'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      isBlocked: map['isBlocked'] ?? false,
      blockedBy: map['blockedBy'],
    );
  }

  FriendsModel copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? createdAt,
    bool? isBlocked,
    String? blockedBy,
  }) {
    return FriendsModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      createdAt: createdAt ?? this.createdAt,
      isBlocked: isBlocked ?? this.isBlocked,
      blockedBy: blockedBy ?? this.blockedBy,
    );
  }

  // 3. Added a fallback return value.
  String getOtherUserId(String userId) {
    if (user1Id == userId) {
      return user2Id;
    } else if (user2Id == userId) {
      return user1Id;
    }
    // Handles cases where the user ID is not part of this model.
    return '';
  }

  // 4. Moved the isBlockedBy method to the correct scope.
  bool isBlockedBy(String userId) {
    return isBlocked && blockedBy == userId;
  }
}
