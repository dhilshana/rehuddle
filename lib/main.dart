import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehuddle/firebase_options.dart';
import 'package:rehuddle/screens/auth_screens/login_screen.dart';
import 'package:rehuddle/view_models/chat_screen_view_model.dart';
import 'package:rehuddle/view_models/home_view_model.dart';
import 'package:rehuddle/view_models/login_view_model.dart';
import 'package:rehuddle/view_models/profile_view_model.dart';
import 'package:rehuddle/view_models/register_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

OneSignal.initialize("9de042a6-8adc-4941-9400-bfd6b0e79c5d");


// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
OneSignal.Notifications.requestPermission(true);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProfileViewModel(),),
      ChangeNotifierProvider(create: (context) => RegisterViewModel(),),
      ChangeNotifierProvider(create: (context) => HomeViewModel(),),
      ChangeNotifierProvider(create: (context) => LoginViewModel(),),
      ChangeNotifierProvider(create: (context) => ChatScreenViewModel(),),

    ],
    
    child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 805),
      minTextAdapt: true,
      splitScreenMode: true,
      child: const MaterialApp(
        home:LoginScreen(),
      ),
    );
  }
}
