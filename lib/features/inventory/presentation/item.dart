import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MyItem extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  const MyItem({super.key, this.width, this.height, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = this.width ?? MediaQuery.of(context).size.width * 0.2;
    double height = this.height ?? MediaQuery.of(context).size.height * 0.2;
    return MyContainer(
      width: width,
      height: height,
      // color: Colors.blue,
      child: Center(child: MyText(text: text)),
    );
  }
}
