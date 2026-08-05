import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/widgets/tab.dart';

class MyTabView extends StatefulWidget {
  /// [childrenTabIcons] is represents the children's contents
  final List<MyTab> childrenTabIcons;
  final List<Widget> children;
  final bool isTabsOnTop; // not yet implemented

  const MyTabView({
    super.key,
    required this.children,
    required this.childrenTabIcons,
    this.isTabsOnTop = true,
  });

  @override
  State<MyTabView> createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView> {
  @override
  void initState() {
    super.initState();

    if (widget.children.length != widget.childrenTabIcons.length) {
      throw Exception(
        "The children and childrenTabIcons must be the same length as they are related to each other.",
      );
    }
    log(
      "children: ${widget.children.length} | tabs: ${widget.childrenTabIcons.length}",
    );
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: widget.children.length,
        child: Column(
          children: [
            Expanded(child: TabBarView(children: widget.children)),
            TabBar(tabs: widget.childrenTabIcons),
            SizedBox(height: MyAppLayout.bottomNavbarHeight * 0.075),
          ],
        ),
      ),

      // 1. Move the TabBar to the bottomNavigationBar
      // bottomNavigationBar: (widget.isTabsOnTop)
      //     ? SafeArea(
      //         // 2. Wrap in a SizedBox to force a smaller height
      //         child: SizedBox(
      //           height: 55,
      //           child: TabBar(
      //             // Style the tabs so they look good at the bottom
      //             labelColor: Colors.blue,
      //             unselectedLabelColor: Colors.grey,
      //             indicatorColor: Colors.blue,
      //             // Move the indicator to the top of the tab for a classic bottom-nav look
      //             indicatorPadding: EdgeInsets.zero,
      //             tabs: widget.childrenTabIcons,
      //           ),
      //         ),
      //       )
      //     : SizedBox(),
    );
  }
}
