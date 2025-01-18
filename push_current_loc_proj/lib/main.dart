import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:push_current_loc_proj/src/form/service/firebase_service.dart';
import 'package:push_current_loc_proj/src/form/ui/form_page.dart';
import 'package:push_current_loc_proj/utils/sizer.dart';
import 'package:push_current_loc_proj/utils/theme.dart';

import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request Firebase permission
  PushNotifications.requestFirebasePermission().then((value) {
    PushNotifications.generateFirebaseToken();
  });

  // Initialize local notifications
  PushNotifications.localNotiInit();

  // Set up Firebase messaging for foreground and background notifications
  PushNotifications.setUpFirebaseMessaging();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home:  ContactsScreen(),
          // getPages: StorePageRoute.mainPageRoute,
          theme: appPrimaryTheme,
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}