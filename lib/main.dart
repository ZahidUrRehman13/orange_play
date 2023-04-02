import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orange_play/menu_screens/home_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orange_play/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: prefs,
  ));


}

class MyApp extends StatelessWidget {
  late SharedPreferences sharedPreferences;

  MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(sharedPreferences)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(microseconds: 0), () {
      Transitioner(
        context: context,
        child: HomeScreen(),
        animation: AnimationType.fadeIn, // Optional value
        duration: Duration(milliseconds: 1000), // Optional value
        replacement: true, // Optional value
        curveType: CurveType.decelerate, // Optional value
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
