import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyDimensions.getHeight(context) * 0.06,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchAnchor.bar(
        barPadding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        barElevation: WidgetStateProperty.all(2),
        // barPadding: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        //   // If the button is currently being pressed down
        //   if (states.contains(WidgetState.pressed)) {
        //     return const EdgeInsets.all(8);
        //   }
        //   // Default padding for all other states
        //   return const EdgeInsets.all(16);
        // }),
        // viewBarPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // barSide: WidgetStateProperty.all(
        //   BorderSide(color: Colors.grey, width: 1),
        // ),
        viewHeaderHeight: MyDimensions.getHeight(context) * 0.06,
        isFullScreen: false,
        viewHintText: 'Search for items',
        suggestionsBuilder: (context, controller) {
          return [
            ListTile(
              title: Text('Suggestion 1'),
              onTap: () {
                controller.text = 'Suggestion 1';
              },
            ),
            ListTile(
              title: Text('Suggestion 2'),
              onTap: () {
                controller.text = 'Suggestion 2';
              },
            ),
          ];
        },
        onChanged: (String value) {
          // Handle search input changes
        },
      ),
    );
  }
}
