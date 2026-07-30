import 'dart:developer';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/features/account/presentation/account_page.dart';
import 'package:pos_system/features/cashier/presentation/cashier_page.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/home/presentation/home_page.dart';
import 'package:pos_system/features/inventory/presentation/inventory_page.dart';
import 'package:pos_system/features/utang/presentation/utang_page.dart';

class MyRootScaffoldWithNavBar extends ConsumerWidget {
  const MyRootScaffoldWithNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(rootScaffoldStateProvider);
    final isCheckoutOpen = ref.watch(toCheckoutProvider);
    final scannedItems = ref.watch(toCounterItemsProvider);

    ColorScheme myColorScheme = Theme.of(context).colorScheme;
    Color labelAndIconColor = myColorScheme.secondary;

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        onTap: (index) {
          // To have a smoother navigating experience when navigating to other pages if the Checkout interface in the Cashier page is open.
          if (isCheckoutOpen && index != 1) {
            ref.read(toCheckoutProvider.notifier).toggle();
          }
          // Cashier Page
          if (currentIndex == 1 && index == 1) {
            // Don't proceed to checkout interface if there is no scanned items in the counter
            if (!isCheckoutOpen && scannedItems.isEmpty) {
              showMyAnimatedSnackBar(
                context: context,
                icon: Icon(
                  Icons.error_outline_rounded,
                  color: myColorScheme.error,
                ),
                dataToDisplay:
                    "Nothing to checkout in here. \nYou have to scan an item first.",
              );
              return;
            }
            ref.read(toCheckoutProvider.notifier).toggle();
            log("Scanner toggled");
            return;
          }

          ref.read(toCheckoutProvider.notifier).toggle(false);
          ref.read(rootScaffoldStateProvider.notifier).changeIndex(index);
        },
        backgroundColor: Colors.transparent,
        height: MyAppLayout.bottomNavbarHeight,
        color: myColorScheme.secondaryContainer,

        buttonBackgroundColor: _myFloatingButtonColorDeterminer(
          currentIndex: currentIndex,
          isCheckoutOpen: isCheckoutOpen,
          myColorScheme: myColorScheme,
        ),

        items: [
          _myCurvedNavigationBarItem(
            label: 'Home',
            color: labelAndIconColor,
            icon: _toVertiCenterIcon(
              isTheCurretIndex: (currentIndex == 0),
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome04),
            ),
          ),

          _myCurvedNavigationBarItem(
            label: (currentIndex == 1 && isCheckoutOpen)
                ? 'Checkout'
                : 'Cashier',
            color: labelAndIconColor,
            icon: _toVertiCenterIcon(
              isTheCurretIndex: (currentIndex == 1),
              hasSpecialVisual: (currentIndex == 1 && isCheckoutOpen),
              icon: (currentIndex == 1)
                  ? AnimatedCrossFade(
                      firstChild: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowDown01,
                      ),
                      secondChild: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowUp01,
                      ),
                      crossFadeState: (isCheckoutOpen)
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      sizeCurve: Curves.easeInOut,
                      duration: Duration(milliseconds: 200),
                    )
                  : HugeIcon(icon: HugeIcons.strokeRoundedCashier),
            ),
          ),

          _myCurvedNavigationBarItem(
            label: 'Inventory',
            color: labelAndIconColor,
            icon: _toVertiCenterIcon(
              isTheCurretIndex: (currentIndex == 2),
              icon: HugeIcon(icon: HugeIcons.strokeRoundedGroupItems),
            ),
          ),

          _myCurvedNavigationBarItem(
            label: 'Utang',
            color: labelAndIconColor,
            icon: _toVertiCenterIcon(
              isTheCurretIndex: (currentIndex == 3),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedReceiptText,
                size: 24,
              ),
            ),
          ),

          _myCurvedNavigationBarItem(
            label: 'Account',
            color: myColorScheme.secondary,
            icon: _toVertiCenterIcon(
              isTheCurretIndex: (currentIndex == 4),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedAccountSetting03,
                size: 26,
              ),
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

  CurvedNavigationBarItem _myCurvedNavigationBarItem({
    required String label,
    required Color color,
    required Widget icon,
  }) {
    return CurvedNavigationBarItem(
      label: label,
      labelStyle: TextStyle(color: color, fontFamily: "Quicksand"),
      child: icon,
    );
  }

  Widget _toVertiCenterIcon({
    required Widget icon,
    required bool isTheCurretIndex,
    bool hasSpecialVisual = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: (isTheCurretIndex) ? 0 : 8),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, hasSpecialVisual ? 12.0 : 0, 0),
      child: icon,
    );
  }

  /// Return a special buttons when in the Cashier page and the checkout is open
  Color _myFloatingButtonColorDeterminer({
    required int currentIndex,
    required bool isCheckoutOpen,
    required ColorScheme myColorScheme,
  }) {
    if (currentIndex == 1 && isCheckoutOpen) {
      return Colors.transparent;
    } else if (currentIndex == 1) {
      return myColorScheme.primary;
    } else {
      return myColorScheme.primaryContainer;
    }
  }
}
