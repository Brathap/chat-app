class ChatRoom {
  final String id;
  final List<String> userIds;
  final String lastMessage;
  final DateTime lastMessageTimestamp;

  ChatRoom({
    required this.id,
    required this.userIds,
    this.lastMessage = '',
    required this.lastMessageTimestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userIds': userIds,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      userIds: List<String>.from(map['userIds']),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTimestamp: map['lastMessageTimestamp'].toDate(),
    );
  }
}
