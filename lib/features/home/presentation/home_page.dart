import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: myColorScheme.surface,
      body: Center(child: const MyText(text: "Home Page")),
    );
  }
}
