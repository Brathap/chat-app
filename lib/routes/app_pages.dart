import 'package:get/get.dart';
import 'package:new_assign/bindings/chat_binding.dart';
import 'package:new_assign/bindings/forgot_password_binding.dart';
import 'package:new_assign/bindings/login_binding.dart';
import 'package:new_assign/bindings/main_binding.dart';
import 'package:new_assign/bindings/register_binding.dart';
import 'package:new_assign/routes/app_routes.dart';
import 'package:new_assign/views/auth/forgot_password_view.dart';
import 'package:new_assign/views/auth/login_view.dart';
import 'package:new_assign/views/auth/register_view.dart';
import 'package:new_assign/views/chat/chat_view.dart';
import 'package:new_assign/views/main/main_view.dart';
import 'package:new_assign/views/splash_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    // The HomeView is now part of the MainView's PageView
    // and doesn't need a separate route.
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
  ];
}
