import 'dart:developer';

import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/sales/data/model/sales_model.dart';
import 'package:pos_system/features/sales/domain/sales_view_option.dart';
import 'package:pos_system/features/sales/domain/weekly_sales_view.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_controller.g.dart';

@Riverpod(keepAlive: true)
class SalesController extends _$SalesController {
  @override
  Future<List<SalesModel>> build() async {
    // await Future.delayed(const Duration(seconds: 2));
    log("The build method was executed!");
    final sales = await getSalesThisWeek();
    sales.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    log("The build method have finished executing!");

    return sales;
  }

  Future<void> saveToFirebase({
    required List<ScannedItem> items,
    required double payment,
    required double change,
  }) async {
    try {
      final salesRepo = ref.read(salesRepoProvider);

      List<String> itemIDandQty = [];
      for (var item in items) {
        String i = "${item.id!}:${item.quantity}";
        itemIDandQty.add(i);
      }

      double totalAmount = items.fold<double>(0, (total, currentVal) {
        return total + (currentVal.price * currentVal.quantity);
      });

      String loggedInUserID = ref
          .read(currentLoggedInUserControllerProvider)
          .value!
          .id!;

      // await salesRepo.add(
      //   SalesModel(
      //     particulars: itemIDandQty,
      //     totalAmount: totalAmount,
      //     payment: payment,
      //     change: change,
      //     dateTime: DateTime.now().toString(),
      //     cashierId: loggedInUserID,
      //   ),
      // );

      final newSale = SalesModel(
        particulars: itemIDandQty,
        totalAmount: totalAmount,
        payment: payment,
        change: change,
        dateTime: DateTime.now().toString(),
        cashierId: loggedInUserID,
      );

      // Save to Database
      await salesRepo.add(newSale);

      // This grabs the current list of sales, adds the new one, and updates the state.
      if (state.hasValue) {
        final currentSales = state.value!;
        state = AsyncValue.data([newSale, ...currentSales]);
      } else {
        // Or simply force the build() method to run again
        ref.invalidateSelf();
      }
    } catch (e, stackTrace) {
      log(
        "An error: $e, occured when calling saveToFirebase in SalesController. Stacktrace: $stackTrace",
      );
    }
  }

  // Future<List<SalesModel>> getAllSales() async {
  //   final salesRepo = ref.read(salesRepoProvider);
  //   final allSales = await salesRepo.getAllRecords();
  //   return allSales;
  // }

  /// Online
  Future<List<SalesModel>> getSalesThisWeek() async {
    final salesRepo = ref.read(salesRepoProvider);
    DateTime now = DateTime.now();

    // Dart considers Monday as weekday 1.
    // Subtracting (weekday - 1) days gets us back to Monday at midnight.
    DateTime fromTheTime = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    log(
      "fromTheTime date: ${MyDateFormatter.formatDate(dateTimeInString: fromTheTime.toString())}",
    );

    // Add 6 days, 23 hours, 59 minutes, and 59 seconds to get to Sunday at 11:59:59 PM.
    DateTime untilTheTime = fromTheTime.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    log(
      "untilTheTime date: ${MyDateFormatter.formatDate(dateTimeInString: untilTheTime.toString())}",
    );

    final allSales = await salesRepo.getRecordsBaseOnTimeSpan(
      fromTheTime: fromTheTime.toString(),
      untilTheTime: untilTheTime.toString(),
    );

    return allSales;
  }

  // Queries are fetched from the cached data in state.
  /// This could be view Weekly or Monthly sales (not yet implemented).
  List<Map<String, double>> getMostSoldProducts({
    SalesViewOption salesViewOption = SalesViewOption.Weekly,
  }) {
    List<ProductModel> inventoryItems =
        ref.read(allListedProductsProvider).value ?? [];
    List<Map<String, double>> mostSoldProducts = [];

    switch (salesViewOption) {
      // case SalesOption.Weekly:
      //   return [];
      default:
        final tempAllSales = weeklySalesView(sales: state.value ?? []);
        log("${tempAllSales.length}");
        log("It works here (after tempAllSales)");
        // for (var sale in tempAllSales) {
        for (int i = 0; i < tempAllSales.length; i++) {
          for (var item in inventoryItems) {
            if (item.barCode == tempAllSales[i].keys.first) {
              mostSoldProducts.add({item.name: tempAllSales[i].values.first});
            }

            // if (sale.keys.first == tempAllSales.last.keys.first) {
            //   log("Other was executed");
            //   mostSoldProducts.add({"Others": tempAllSales.last.values.first});
            // }
          }
          if (i == tempAllSales.length - 1) {
            mostSoldProducts.add({"Others": tempAllSales[i].values.first});
          }
        }
        log("${mostSoldProducts.length}");
        return mostSoldProducts;
    }
  }
}
