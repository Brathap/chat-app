import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_assign/models/user_model.dart';
import 'package:new_assign/routes/app_routes.dart';
import 'package:new_assign/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // --- STATE ---
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // --- GETTERS ---
  UserModel? get userModel => _userModel.value;
  bool get isAuthenticated => _userModel.value != null;
  Rx<UserModel?> get userModelStream => _userModel;

  // --- LIFECYCLE ---
  @override
  void onReady() {
    super.onReady();
    // When the app starts, check the initial auth state.
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      // If the user is already logged in, fetch their profile.
      try {
        final model = await _authService.getUserModel(firebaseUser.uid);
        _userModel.value = model;
      } catch (e) {
        // If fetching fails, the user is effectively logged out.
        _userModel.value = null;
      }
    }
  }

  // --- PUBLIC ACTIONS ---
  // Each action is now a complete unit of work: it performs the action,
  // updates the state, and then navigates.

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    try {
      final userModel = await _authService.signInWithEmailAndPassword(email, password);
      _userModel.value = userModel;
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    isLoading.value = true;
    try {
      final userModel = await _authService.registerWithEmailAndPassword(
          email, password, displayName);
      _userModel.value = userModel;
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final userModel = await _authService.signInWithGoogle();
      _userModel.value = userModel;
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _userModel.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      await _authService.deleteAccount();
      _userModel.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
