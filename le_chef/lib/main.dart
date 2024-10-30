import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:le_chef/Screens/user/Home.dart';
import 'package:le_chef/Screens/Login.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

String? token;
String? role;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  token = sharedPreferences.getString('token');
  role = sharedPreferences.getString('role');
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
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF164863)),
          useMaterial3: true,
        ),
        home: token == null || token == ""
            ? const Login()
            : role == "admin"
                ? THome()
                : Home(),
      ),
    );
  }
}
