import 'package:get/get.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/services/firestore_service.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();

  final RxBool _isLoading = true.obs;
  final RxList<UserModel> _users = <UserModel>[].obs; // Master list of all users
  final RxString _searchQuery = ''.obs; // Holds the current search text

  // This public list will hold the users that match the search query.
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;

  bool get isLoading => _isLoading.value;
  List<UserModel> get users => _users;

  @override
  void onInit() {
    super.onInit();
    // Bind the user stream from Firestore to the internal _users list.
    _users.bindStream(_firestoreService.getUsers());

    // Use everAll to listen to multiple reactive variables.
    // This now correctly runs whenever the master user list OR the search query changes.
    everAll([_users, _searchQuery], (_) => _updateFilteredUsers());

    // This block manages the initial loading state.
    ever(_users, (_) {
      if (_isLoading.value) {
        _isLoading.value = false;
      }
    });
  }

  /// Called by the search bar in the UI whenever the user types.
  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  /// Filters the master user list `_users` based on the `_searchQuery`
  /// and updates the public `filteredUsers` list.
  void _updateFilteredUsers() {
    if (_searchQuery.value.isEmpty) {
      // If the search bar is empty, show all users.
      filteredUsers.assignAll(_users);
    } else {
      // Otherwise, filter by display name (case-insensitive).
      final lowerCaseQuery = _searchQuery.value.toLowerCase();
      filteredUsers.assignAll(
        _users.where((user) =>
            user.displayName.toLowerCase().contains(lowerCaseQuery))
            .toList(),
      );
    }
  }
}
