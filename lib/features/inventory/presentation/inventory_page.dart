import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/features/inventory/presentation/inventory_search_bar.dart';
import 'package:pos_system/features/inventory/presentation/items_area.dart';
import 'package:pos_system/features/inventory/presentation/bottom_inventory_options_bar.dart';
import 'package:pos_system/features/products/presentation/add_product_sheet.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final myColorScheme = Theme.of(context).colorScheme;

    // For inventory options bar container
    final bool isInventoryPageVisible =
        ref.watch(rootScaffoldStateProvider) == 2;
    final double inventoryPageOptionsBarHeight = isInventoryPageVisible
        ? 120
        : 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(bottom: false, child: MyInventorySearchBar()),
              Expanded(child: MyItemsArea()),
              // Spacer(),
              MyBottomInventoryPageOptionsBar(
                isInventoryPageVisible: isInventoryPageVisible,
                inventoryPageOptionsBarHeight: inventoryPageOptionsBarHeight,
                children: [
                  inventoryPageOptions(
                    onTap: () {
                      showMyBottomSheet(
                        context: context,
                        child: AddProductSheet(),
                      );
                    },
                    icon: HugeIcon(icon: HugeIcons.strokeRoundedAddInvoice),
                  ),
                  // Placeholders only
                  inventoryPageOptions(
                    onTap: () {},
                    // icon: HugeIcon(icon: HugeIcons.strokeRoundedFile01),
                  ),
                  SizedBox(width: 32),
                  // Placeholders only
                  inventoryPageOptions(
                    onTap: () {},
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
      ),
    );
  }

  Widget inventoryPageOptions({HugeIcon? icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: MyContainer(
        width: width * 0.16,
        height: height * 0.1,
        borderRadius: 100,
        child: icon ?? Placeholder(),
      ),
    );
  }
}
