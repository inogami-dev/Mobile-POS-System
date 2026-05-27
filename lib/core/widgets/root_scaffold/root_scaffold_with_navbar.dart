import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/constants/app_layout.dart';
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
        height: MyAppLayout.bottomNavbarHeight,
        color: myColorScheme.secondaryContainer,
        buttonBackgroundColor: myColorScheme.primaryContainer,
        items: [
          CurvedNavigationBarItem(
            label: 'Home',
            labelStyle: TextStyle(color: labelAndIconColor),
            child: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
          ),
          CurvedNavigationBarItem(
            label: 'Cashier',
            labelStyle: TextStyle(color: labelAndIconColor),
            child: HugeIcon(icon: HugeIcons.strokeRoundedCashier),
          ),
          CurvedNavigationBarItem(
            label: 'Inventory',
            labelStyle: TextStyle(color: labelAndIconColor),
            child: HugeIcon(icon: HugeIcons.strokeRoundedGroupItems),
          ),
          CurvedNavigationBarItem(
            label: 'Utang',
            labelStyle: TextStyle(color: labelAndIconColor),
            child: HugeIcon(icon: HugeIcons.strokeRoundedReceiptText, size: 26),
          ),
          CurvedNavigationBarItem(
            label: 'Account',
            labelStyle: TextStyle(color: myColorScheme.secondary),
            child: HugeIcon(icon: HugeIcons.strokeRoundedUserAccount, size: 26),
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
