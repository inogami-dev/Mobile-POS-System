import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pos_system/core/themes/theme_state/my_app_theme.dart';
import 'package:pos_system/features/account/presentation/account_page.dart';
import 'package:pos_system/features/authentication/presentation/logged_in_stream.dart';
import 'package:pos_system/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PointOfSaleSystem',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      // ),
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SafeArea(
        top: false,
        // maintainBottomViewPadding: true,
        // child: MyRootScaffoldWithNavBar(),
        // child: loggedInStream(),
        // child: LoginPage(),
        child: AccountPage(),
      ),
    );
  }
}
