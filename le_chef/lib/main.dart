import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:le_chef/Screens/user/Home.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:le_chef/Shared/splash_one.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


SharedPreferences? sharedPreferences;

String? token;
String? role;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  sharedPreferences = await SharedPreferences.getInstance();
  token = sharedPreferences!.getString('token');
  role = sharedPreferences!.getString('role');


  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("29357873-0cf5-4e66-b038-cdf4ce3906b4");

  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the color you want for the status bar
    Color statusBarColor = Colors.white;

    // Apply the status bar color globally
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Le Chef',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF164863)),
          useMaterial3: true,
        ),
        home: token == null || token == ""
            ? const SplashOne()
            : role == "admin"
                ? const THome()
                : const Home(),
      ),
    );
  }
}
