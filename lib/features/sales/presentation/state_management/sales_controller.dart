import 'dart:developer';

import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/sales/data/model/sales_model.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_controller.g.dart';

@Riverpod(keepAlive: true)
class SalesController extends _$SalesController {
  @override
  List<SalesModel> build() {
    return [];
  }

  Future<void> saveToFirebase({
    required List<ScannedItem> items,
    required double payment,
    required double change,
  }) async {
    try {
      final salesRepo = ref.read(salesRepoProvider);

      List<String> itemIDs = [];
      for (var item in items) {
        itemIDs.add(item.id!);
      }

      double totalAmount = items.fold<double>(0, (total, currentVal) {
        return total + (currentVal.price * currentVal.quantity);
      });

      String loggedInUserID = ref
          .read(currentLoggedInUserControllerProvider)
          .value!
          .id!;

      await salesRepo.add(
        SalesModel(
          particulars: itemIDs,
          totalAmount: totalAmount,
          payment: payment,
          change: change,
          dateTime: DateTime.now().toString(),
          cashierId: loggedInUserID,
        ),
      );
    } catch (e, stackTrace) {
      log(
        "An error: $e, occured when calling saveToFirebase in SalesController. Stacktrace: $stackTrace",
      );
    }
  }

  Future<List<SalesModel>> getAllSales() async {
    final salesRepo = ref.read(salesRepoProvider);
    final allSales = await salesRepo.getAllRecords();
    return allSales;
  }
}
