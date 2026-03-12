import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_assign/bindings/initial_binding.dart';
import 'package:new_assign/firebase_options.dart';
import 'package:new_assign/routes/app_pages.dart';
import 'package:new_assign/services/notification_services.dart';
import 'package:new_assign/theme/app_theme.dart';

// Must be a top-level function (not inside a class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, like Firestore,
  // make sure you call `initializeApp` before using them.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
  // You can process the message here if needed.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Using a try-catch block is the most robust way to initialize Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  await NotificationService.instance.initialize(); // Initialize our service

  // Set the background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set up the foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

      // Use our service to show the local notification
      NotificationService.instance.showNotification(
        title: message.notification!.title ?? "New Message",
        body: message.notification!.body ?? "",
        payload: message.data['chatId'], // Example: pass chat ID for navigation
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      // --- THEME CONFIGURATION ---
      theme: AppTheme.lightTheme, // Set the light theme
      darkTheme: AppTheme.darkTheme, // Set the dark theme
      themeMode: ThemeMode.system, // Automatically switch based on system settings
      // ---------------------------
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
