import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:le_chef/Screens/user/Home.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:le_chef/Shared/splash_one.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
String? token;
String? role;
final _noScreenshot = NoScreenshot.instance;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  token = sharedPreferences!.getString('token');
  role = sharedPreferences!.getString('role');

  bool result = await _noScreenshot.screenshotOff();
  debugPrint('Screenshot Off: $result');


  print('Token from main: $token');
  print('Role from main: $role');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    Color statusBarColor = Colors.white;

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
        home: _determineHomeScreen(),
      ),
    );
  }

  Widget _determineHomeScreen() {
    // Check if user is logged in and has a role
    if (token != null && token!.isNotEmpty) {
      if (role == "admin") {
        return const THome();
      } else {
        return const Home();
      }
    }
    return const SplashOne();
  }
}