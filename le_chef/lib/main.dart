import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:le_chef/Screens/user/Home.dart';
import 'package:le_chef/Screens/admin/THome.dart';
import 'package:le_chef/Shared/splash_one.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

SharedPreferences? sharedPreferences;
String? token;
String? role;
final _noScreenshot = NoScreenshot.instance;

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  final RxBool isConnected = true.obs;
  bool isDialogOpen = false;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Could not get connectivity status: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool wasConnected = isConnected.value;
    isConnected.value = results.any((result) => result != ConnectivityResult.none);

    if (wasConnected && !isConnected.value) {
      _showConnectionLostDialog();
    }
    else if (!wasConnected && isConnected.value && isDialogOpen) {
      Get.back();
      isDialogOpen = false;
    }
  }

  void _showConnectionLostDialog() {
    if (!isDialogOpen) {
      isDialogOpen = true;
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Connection Lost'),
            content: const Text('Your internet connection appears to be offline. Please check your connection.'),
            // No buttons as requested
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  Future<void> checkConnection() async {
    await _initConnectivity();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  token = sharedPreferences!.getString('token');
  role = sharedPreferences!.getString('role');

  bool result = await _noScreenshot.screenshotOff();
  debugPrint('Screenshot Off: $result');

  print('Token from main: $token');
  print('Role from main: $role');

  // Initialize the connectivity controller
  Get.put(ConnectivityController(), permanent: true);

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