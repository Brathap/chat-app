import 'package:get/get.dart';
import 'package:new_assign/controllers/auth_controller.dart';
import 'package:new_assign/models/friend_request_model.dart';
import 'package:new_assign/models/friends_model.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

enum UserRelationshipStatus {
  none,
  friendRequestSent,
  friendRequestReceived,
  friends,
  blocked,
}

class UsersListController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthController _authController = Get.find<AuthController>();
  final Uuid _uuid = const Uuid();

  final RxList<UserModel> _allUsers = <UserModel>[].obs;
  final RxList<FriendRequestModel> _sentRequests = <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> _receivedRequests = <FriendRequestModel>[].obs;
  final RxList<FriendsModel> _friendships = <FriendsModel>[].obs;
  final RxMap<String, UserRelationshipStatus> _userRelationships =
      <String, UserRelationshipStatus>{}.obs;

  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;

  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  bool get isLoading => _isLoading.value;
  Map<String, UserRelationshipStatus> get userRelationships =>
      _userRelationships;

  @override
  void onInit() {
    super.onInit();
    _loadDataStreams();

    debounce(
      _searchQuery,
      (_) => _updateFilteredUsers(),
      time: const Duration(milliseconds: 300),
    );
  }

  void _loadDataStreams() {
    final currentUserId = _authController.userModel?.id;
    if (currentUserId == null) return;

    _isLoading.value = true;

    _allUsers.bindStream(_firestoreService.getUsers());
    _sentRequests
        .bindStream(_firestoreService.getSentFriendRequestsStream(currentUserId));
    _receivedRequests.bindStream(
        _firestoreService.getReceivedFriendRequestsStream(currentUserId));
    _friendships.bindStream(_firestoreService.getFriendsStream(currentUserId));

    ever(_allUsers, (_) => _updateAllStatusesAndFilters());
    ever(_sentRequests, (_) => _updateAllStatusesAndFilters());
    ever(_receivedRequests, (_) => _updateAllStatusesAndFilters());
    ever(_friendships, (_) => _updateAllStatusesAndFilters());

    _isLoading.value = false;
  }

  void _updateAllStatusesAndFilters() {
    _updateAllRelationshipStatuses();
    _updateFilteredUsers();
  }

  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  void _updateFilteredUsers() {
    final currentUserId = _authController.userModel?.id;
    if (currentUserId == null) return;

    final otherUsers = _allUsers.where((user) => user.id != currentUserId).toList();

    if (_searchQuery.value.isEmpty) {
      filteredUsers.value = otherUsers;
    } else {
      final lowerCaseQuery = _searchQuery.value.toLowerCase();
      filteredUsers.value = otherUsers
          .where((user) =>
              user.displayName.toLowerCase().contains(lowerCaseQuery))
          .toList();
    }
  }

  void _updateAllRelationshipStatuses() {
    final currentUserId = _authController.userModel?.id;
    if (currentUserId == null) return;

    final newRelationships = <String, UserRelationshipStatus>{};
    for (var user in _allUsers) {
      if (user.id == currentUserId) continue;
      newRelationships[user.id] =
          _calculateRelationshipStatus(currentUserId, user.id);
    }
    _userRelationships.value = newRelationships;
  }

  UserRelationshipStatus _calculateRelationshipStatus(
      String currentUserId, String otherUserId) {
    final friendship = _friendships.firstWhereOrNull((f) =>
        (f.user1Id == currentUserId && f.user2Id == otherUserId) ||
        (f.user1Id == otherUserId && f.user2Id == currentUserId));

    if (friendship != null) {
      return friendship.isBlocked
          ? UserRelationshipStatus.blocked
          : UserRelationshipStatus.friends;
    }

    final sentRequest =
        _sentRequests.firstWhereOrNull((r) => r.receiverId == otherUserId);
    if (sentRequest != null) {
      return UserRelationshipStatus.friendRequestSent;
    }

    final receivedRequest =
        _receivedRequests.firstWhereOrNull((r) => r.senderId == otherUserId);
    if (receivedRequest != null) {
      return UserRelationshipStatus.friendRequestReceived;
    }

    return UserRelationshipStatus.none;
  }

  // Updated to create and send a rich FriendRequestModel
  void sendFriendRequest(String recipientId) {
    final sender = _authController.userModel;
    if (sender == null) return;

    // Find the recipient's user model from the list of all users
    final recipient = _allUsers.firstWhereOrNull((user) => user.id == recipientId);
    if (recipient == null) return;

    final newRequest = FriendRequestModel(
      id: _uuid.v4(),
      senderId: sender.id,
      senderName: sender.displayName,
      senderAvatarUrl: sender.photoUrl,
      receiverId: recipient.id,
      receiverName: recipient.displayName,
      receiverAvatarUrl: recipient.photoUrl,
      createdAt: DateTime.now(),
      status: FriendRequestStatus.pending,
    );

    _firestoreService.sendFriendRequest(newRequest);
  }

  void acceptFriendRequest(String senderId) {
    final currentUserId = _authController.userModel?.id;
    if (currentUserId == null) return;

    final request = _receivedRequests.firstWhereOrNull((r) => r.senderId == senderId);
    if (request != null) {
      _firestoreService.acceptFriendRequest(request);
    }
  }

  void cancelFriendRequest(String userId) {
    final request = _sentRequests.firstWhereOrNull((r) => r.receiverId == userId);
    if (request != null) {
      _firestoreService.deleteFriendRequest(request.id);
    }
  }
}
