import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/line.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/cashier/presentation/widgets/counter_scanner.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_area.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_checkout_area.dart';

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  late double width;
  late double height;
  ScrollController scrollController = ScrollController();
  bool isKeyboardOpen = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;
    List<ScannedItem> scannedItems = ref.watch(toCounterItemsProvider);
    int currentIndex = ref.watch(rootScaffoldStateProvider);
    final toCheckout = ref.watch(toCheckoutProvider);

    return Scaffold(
      body: Focus(
        onFocusChange: (hasFocus) {
          setState(() => isKeyboardOpen = hasFocus);
        },
        child: Container(
          width: width,
          // height: height,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    // if (currentIndex == 1 && !toCheckout) // for further testing
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: (currentIndex == 1 && !toCheckout)
                          ? height * 0.4
                          : 0,
                      curve: Curves.easeInOutCubic,
                      child: AnimatedOpacity(
                        opacity: (toCheckout) ? 0 : 1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.easeInOutCubic,
                        child: SafeArea(
                          bottom: false,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            child: MyCounterScanner(
                              isTurnedOff: (currentIndex == 1 && toCheckout),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyLine(
                            length: width / 3,
                            isVertical: false,
                            color: myColorScheme.outline.withAlpha(80),
                          ),
                          MyText(
                            text: "Particulars",
                            fontSize: kDefaultFontSize - 4,
                          ),
                          MyLine(
                            length: width / 3,
                            isVertical: false,
                            color: myColorScheme.outline.withAlpha(80),
                          ),
                        ],
                      ),
                    ),
                    ParticularsArea(
                      scrollController: scrollController,
                      height: height,
                      scannedItems: scannedItems,
                      myColorScheme: myColorScheme,
                      width: width,
                    ),
                  ],
                ),
              ),

              // Bottom Extra Background
              AnimatedPositioned(
                bottom: (toCheckout)
                    ? ((isKeyboardOpen) ? -100 : 0)
                    : -(height * 0.23),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: Container(
                  width: width,
                  height: MyAppLayout.bottomNavbarHeight + 8,
                  color: myColorScheme.outline,
                  // color: Colors.amber,
                ),
              ),

              AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                bottom: (toCheckout)
                    ? ((isKeyboardOpen) ? 0 : height * 0.085)
                    : -(height * 0.115),
                child: ParticularsCheckoutArea(scannedItems: scannedItems),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
