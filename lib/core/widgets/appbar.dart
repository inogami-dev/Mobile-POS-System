import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MyAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? actionsButtons;
  final bool enableBackButton;
  const MyAppBar({
    super.key,
    required this.title,
    this.actionsButtons,
    this.enableBackButton = false,
  });

  @override
  State<MyAppBar> createState() => My_AppBarState();
}

class My_AppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MyDimensions.getWidth(context),
      height: kToolbarHeight,
      color: myColorScheme.secondaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (widget.enableBackButton)
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                )
              : SizedBox(width: 16),

          Expanded(
            child: MyText(
              text: widget.title,
              fontSize: kDefaultFontSize + 6,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16),

          ...widget.actionsButtons ?? [],

          SizedBox(width: 16),
        ],
      ),
    );
  }
}
