import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/navigator.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/core/widgets/tooltip.dart';
import 'package:pos_system/features/inventory/presentation/inventory_search_bar.dart';
import 'package:pos_system/features/inventory/presentation/items_area.dart';
import 'package:pos_system/features/inventory/presentation/bottom_inventory_options_bar.dart';
import 'package:pos_system/features/products/presentation/add_product_form.dart';
import 'package:pos_system/features/sales/presentation/sales_page.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  late double width;
  late double height;
  late ColorScheme myColor;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    myColor = Theme.of(context).colorScheme;

    // final xs = ref.read(allListedProductsProvider).value;
    // if (xs != null) {
    //   log("XS is not null");
    //   for (var x in xs) {
    //      if (x.cost == null || x.cost == 0) {
    //     final repo = ref.read(
    //       productRepositoryProvider(
    //         ref
    //             .read(currentLoggedInUserControllerProvider)
    //             .value!
    //             .currentStoreInView,
    //       ),
    //     );
    //     repo.update(x.id!, x.copyWith(cost: x.price - 5));
    //     repo.update(x.id!, x.copyWith(category: ""));
    //     log("Successful cost integration: ${x.id}");
    //     }
    //   }
    // }

    // For inventory options bar container
    final bool isInventoryPageVisible =
        ref.watch(rootScaffoldStateProvider) == 2;
    final double inventoryPageOptionsBarHeight = isInventoryPageVisible
        ? 120
        : 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: width,
              height: height,
              padding: EdgeInsets.only(top: kToolbarHeight - 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      opacity: isInventoryPageVisible ? 1 : 0,
                      child: MyItemsArea(),
                    ),
                  ),
                  // Spacer(),
                  MyBottomInventoryPageOptionsBar(
                    isInventoryPageVisible: isInventoryPageVisible,
                    inventoryPageOptionsBarHeight:
                        inventoryPageOptionsBarHeight,
                    children: [
                      inventoryPageOptions(
                        icon: HugeIcon(icon: HugeIcons.strokeRoundedAddInvoice),
                        tooltipMessage: "Add Product",
                        onTap: () {
                          // showMyBottomSheet(
                          //   context: context,
                          //   child: AddProductSheet(),
                          // );
                          MyNavigator.goTo(
                            context,
                            AddProductForm(),
                            animationType: MyAnimationType.slideFromBottom,
                          );
                        },
                      ),
                      // Placeholders only
                      inventoryPageOptions(
                        onTap: () {},
                        // icon: HugeIcon(icon: HugeIcons.strokeRoundedFile01),
                      ),
                      SizedBox(width: 32),
                      // Placeholders only
                      inventoryPageOptions(
                        icon: HugeIcon(icon: HugeIcons.strokeRoundedChart),
                        tooltipMessage: "Sales Report",
                        onTap: () {
                          MyNavigator.goTo(
                            context,
                            MySalesPage(),
                            animationType: MyAnimationType.slideFromBottom,
                          );
                        },
                        // icon: HugeIcon(icon: HugeIcons.strokeRoundedEdit02),
                      ),
                      // Placeholders only
                      inventoryPageOptions(
                        onTap: () {},
                        // icon: HugeIcon(icon: HugeIcons.strokeRoundedDelete03),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              // top: kToolbarHeight,
              child: SafeArea(bottom: false, child: MyInventorySearchBar()),
            ),
          ],
        ),
      ),
    );
  }

  Widget inventoryPageOptions({
    HugeIcon? icon,
    required VoidCallback onTap,
    String? tooltipMessage,
  }) {
    return MyTooltip(
      message: tooltipMessage ?? "",
      child: GestureDetector(
        onTap: onTap,
        child: MyContainer(
          width: width * 0.16,
          height: height * 0.1,
          color: myColor.surface.withAlpha(100),
          borderColor: myColor.outlineVariant,
          borderRadius: 8,
          child: icon ?? Placeholder(),
        ),
      ),
    );
  }
}
