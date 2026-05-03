import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/features/account/presentation/account_page.dart';
import 'package:pos_system/features/cashier/presentation/cashier_page.dart';
import 'package:pos_system/features/home/presentation/home_page.dart';
import 'package:pos_system/features/inventory/presentation/inventory_page.dart';
import 'package:pos_system/features/utang/presentation/utang_page.dart';

class MyRootScaffoldWithNavBar extends ConsumerWidget {
  const MyRootScaffoldWithNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(rootScaffoldStateProvider);
    ColorScheme myColorScheme = Theme.of(context).colorScheme;
    Color labelAndIconColor = myColorScheme.secondary;

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        onTap: (index) {
          ref.read(rootScaffoldStateProvider.notifier).changeIndex(index);
        },
        backgroundColor: Colors.transparent,
        height: kBottomNavigationBarHeight,
        color: myColorScheme.secondaryContainer,
        buttonBackgroundColor: myColorScheme.primaryContainer,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined, color: labelAndIconColor),
            label: 'Home',
            labelStyle: TextStyle(color: labelAndIconColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.search, color: labelAndIconColor),
            label: 'Cashier',
            labelStyle: TextStyle(color: labelAndIconColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline, color: labelAndIconColor),
            label: 'Inventory',
            labelStyle: TextStyle(color: labelAndIconColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.newspaper, color: labelAndIconColor),
            label: 'Utang',
            labelStyle: TextStyle(color: labelAndIconColor),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity, color: labelAndIconColor),
            label: 'Account',
            labelStyle: TextStyle(color: myColorScheme.secondary),
          ),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: _mainPages),
      extendBody: true,
    );
  }

  static const List<Widget> _mainPages = [
    HomePage(),
    CashierPage(),
    InventoryPage(),
    UtangPage(),
    AccountPage(),
  ];
}
