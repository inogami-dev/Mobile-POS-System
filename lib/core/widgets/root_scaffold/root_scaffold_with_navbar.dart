import 'dart:developer';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/features/account/presentation/account_page.dart';
import 'package:pos_system/features/cashier/presentation/cashier_page.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
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
          if (currentIndex == 1 && index == 1) {
            ref.read(toCheckoutProvider.notifier).toggle();
            log("Scanner toggled");
            return; // STOP here. Do not navigate.
          }
          // If we navigate anywhere else (or navigate to Cashier for the first time),
          // ensure the scanner state is forced closed!
          ref.read(toCheckoutProvider.notifier).toggle(false);
          // Proceed with normal navigation
          ref.read(rootScaffoldStateProvider.notifier).changeIndex(index);
        },
        backgroundColor: Colors.transparent,
        height: MyAppLayout.bottomNavbarHeight,
        color: myColorScheme.secondaryContainer,
        buttonBackgroundColor: (currentIndex == 1)
            ? myColorScheme.primary
            : myColorScheme.primaryContainer,
        items: [
          CurvedNavigationBarItem(
            label: 'Home',
            labelStyle: TextStyle(
              color: labelAndIconColor,
              fontFamily: "Quicksand",
            ),
            child: toVertiCenterIcon(
              HugeIcon(icon: HugeIcons.strokeRoundedHome04),
            ),
          ),
          CurvedNavigationBarItem(
            label: (currentIndex == 1) ? 'Checkout' : 'Cashier',
            labelStyle: TextStyle(
              color: labelAndIconColor,
              fontFamily: "Quicksand",
            ),
            child: toVertiCenterIcon(
              (currentIndex == 1)
                  ? HugeIcon(icon: HugeIcons.strokeRoundedArrowUp01)
                  : HugeIcon(icon: HugeIcons.strokeRoundedCashier),
            ),
          ),
          CurvedNavigationBarItem(
            label: 'Inventory',
            labelStyle: TextStyle(
              color: labelAndIconColor,
              fontFamily: "Quicksand",
            ),
            child: toVertiCenterIcon(
              HugeIcon(icon: HugeIcons.strokeRoundedGroupItems),
            ),
          ),
          CurvedNavigationBarItem(
            label: 'Utang',
            labelStyle: TextStyle(
              color: labelAndIconColor,
              fontFamily: "Quicksand",
            ),
            child: toVertiCenterIcon(
              HugeIcon(icon: HugeIcons.strokeRoundedReceiptText, size: 24),
            ),
          ),
          CurvedNavigationBarItem(
            label: 'Account',
            labelStyle: TextStyle(
              color: myColorScheme.secondary,
              fontFamily: "Quicksand",
              wordSpacing: 3.0,
            ),
            child: toVertiCenterIcon(
              HugeIcon(icon: HugeIcons.strokeRoundedAccountSetting03, size: 26),
            ),
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

  // Vertically center the icon visually
  Container toVertiCenterIcon(HugeIcon icon) {
    return Container(
      alignment: Alignment.bottomCenter,
      // padding: EdgeInsets.only(bottom: 2),
      child: icon,
    );
  }
}
