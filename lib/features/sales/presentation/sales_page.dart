import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MySalesPage extends StatefulWidget {
  const MySalesPage({super.key});

  @override
  State<MySalesPage> createState() => _MySalesPageState();
}

class _MySalesPageState extends State<MySalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: "Sales", fontSize: 24, fontWeight: FontWeight.w600),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            // color: Colors.amber,
            padding: const EdgeInsets.only(
              left: 8,
              top: 8,
              bottom: 8,
              right: 0,
            ),
            child: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
          ),
        ),
        leadingWidth: 45,
      ),
      body: Center(child: MyText(text: "Hello")),
    );
  }
}
