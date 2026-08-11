import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/core/widgets/tab.dart';

class MyTabView extends ConsumerStatefulWidget {
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
  ConsumerState<MyTabView> createState() => _MyTabViewState();
}

class _MyTabViewState extends ConsumerState<MyTabView> {
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
    final myColorScheme = Theme.of(context).colorScheme;
    final currentIndex = ref.watch(rootScaffoldStateProvider);
    bool isCurrentlyInSalesPage = currentIndex == 3;

    return Scaffold(
      body: DefaultTabController(
        length: widget.children.length,
        child: Column(
          children: [
            Expanded(child: TabBarView(children: widget.children)),
            AnimatedOpacity(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              opacity: (isCurrentlyInSalesPage) ? 1 : 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                height: (isCurrentlyInSalesPage) ? 56 : 0,
                decoration: BoxDecoration(
                  color: myColorScheme.surfaceContainer,
                  border: Border(
                    top: BorderSide(
                      width: 0.4,
                      color: myColorScheme.onSurface.withAlpha(156),
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TabBar(
                    indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        width: 4.0,
                        color: myColorScheme.primary,
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabs: widget.childrenTabIcons,
                  ),
                ),
              ),
            ),
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
