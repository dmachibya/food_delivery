import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/app_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Food Ordering System',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routerDelegate: RouterHelper.router.routerDelegate,
      routeInformationParser: RouterHelper.router.routeInformationParser,
      routeInformationProvider: RouterHelper.router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
    );
  }
}
