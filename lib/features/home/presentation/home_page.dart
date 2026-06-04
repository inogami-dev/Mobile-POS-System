import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/presentation/state_management/all_users_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    // return Scaffold(
    //   backgroundColor: myColorScheme.surface,
    //   body: Center(child: const MyText(text: "Home Page")),
    // );

    return Scaffold(
      body: Center(child: MyText(text: "Home Page")),
    );
  }
}
