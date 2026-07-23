import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
// import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
// import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';
import 'package:pos_system/features/products/presentation/state_management/queried_products.dart';

class MySearchBar extends ConsumerStatefulWidget {
  const MySearchBar({super.key});

  @override
  ConsumerState<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends ConsumerState<MySearchBar> {
  SearchController searchController = SearchController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final storeInfo = ref.watch(currentLoggedInUserControllerProvider);
    // final productRepoRef = ref.watch(
    //   productRepositoryProvider(storeInfo.value!.currentStoreInView),
    // );
    final myColorScheme = Theme.of(context).colorScheme;

    return Container(
      height: MyDimensions.getHeight(context) * 0.06,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchAnchor.bar(
        searchController: searchController,
        barElevation: WidgetStateProperty.all(2),
        viewHeaderHeight: MyDimensions.getHeight(context) * 0.06,
        isFullScreen: false,
        barPadding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
        barHintText: 'Filter or Search for Products',
        barHintStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: kDefaultFontSize + 1.5,
            color: myColorScheme.onSurface.withAlpha(170),
          ),
        ),
        viewHintText: 'Search for items',
        viewHeaderHintStyle: TextStyle(
          color: myColorScheme.onSurface.withAlpha(170),
        ),
        viewConstraints: const BoxConstraints(maxHeight: 200),
        viewBuilder: (Iterable<Widget> suggestions) {
          // NOTE: The arguments of the Iterable suggestions parameter came from suggestionsBuilder property
          return Theme(
            data: Theme.of(context).copyWith(
              scrollbarTheme: ScrollbarThemeData(
                // Keep your custom primary color here!
                thumbColor: WidgetStateProperty.all(
                  myColorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
            child: RawScrollbar(
              // Force the scrollbar to be permanently visible
              thumbVisibility: true,
              thickness: 6.0,
              mainAxisMargin: 5,
              padding: EdgeInsets.only(bottom: 20),
              radius: const Radius.circular(10),
              child: ListView(
                padding: EdgeInsets.zero, // Removes weird default top padding
                // Convert the iterable of widgets into a standard list!
                children: suggestions.toList(),
              ),
            ),
          );
        },
        onClose: () {
          Future.delayed(Duration(milliseconds: 100), () {
            // FocusManager.instance.primaryFocus?.unfocus();
            FocusScope.of(context).unfocus();
          });

          ref.read(queriedProductsProvider.notifier).resetQueryState();
        },
        suggestionsBuilder: (context, controller) async {
          final query = controller.text.trim();

          if (query.isEmpty) {
            return const [
              ListTile(
                leading: Icon(Icons.history),
                title: MyText(text: 'Start typing to search products...'),
              ),
            ];
          }

          // THE DEBOUNCER: Wait for 500ms. If the user types another letter
          // before 500ms is up, the previous search is cancelled!
          await Future.delayed(const Duration(milliseconds: 300));
          if (query != controller.text.trim()) {
            return [];
          }

          log("Fetching...");
          // List<ProductModel> fetchedProducts = await productRepoRef.getByQuery(
          //   field: 'queryName',
          //   value: controller.text.trim(),
          // );
          List<ProductModel> allProducts =
              ref.read(allListedProductsProvider).value ?? [];
          List<ProductModel> fetchedProducts = allProducts.where((product) {
            // .contains() is the exact equivalent of SQL %LIKE%
            // return product.name.toLowerCase().contains(query.toLowerCase());
            return product.queryName.contains(query.toLowerCase());
          }).toList();

          log("fetched products: ${fetchedProducts.length.toString()}");
          log("Done Fetching!");

          // 3. HANDLE "NO RESULTS"
          if (fetchedProducts.isEmpty) {
            return const [
              ListTile(
                leading: Icon(Icons.hourglass_empty_rounded),
                title: MyText(text: 'No products found.'),
              ),
            ];
          }

          return fetchedProducts.map((product) {
            return MySearchAnchorBarSuggestion(
              product: product,
              controller: controller,
            );
          }).toList();
        },
      ),
    );
  }
}

class MySearchAnchorBarSuggestion extends ConsumerWidget {
  // final SearchController controller;
  // const MySearchAnchorBarSuggestion({super.key, required this.controller});

  final ProductModel product;
  final SearchController controller;

  MySearchAnchorBarSuggestion({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: MyImageDisplayer(
          imageInBase64Format: MyImageProcessor.decodeStringToUint8List(
            product.picture,
          ),
          isOval: false,
        ),
      ),
      title: MyText(
        text: product.name,
        fontSize: kDefaultFontSize + 4,
        fontWeight: FontWeight.w600,
      ),
      subtitle: MyText(
        text: product.description,
        fontSize: kDefaultFontSize - 1,
      ),
      onTap: () {
        controller.closeView(product.name);
        ref.read(queriedProductsProvider.notifier).setQueriedProducts([
          product,
        ]);
        // controller.text = 'Suggestion 1';
      },
    );
  }
}
