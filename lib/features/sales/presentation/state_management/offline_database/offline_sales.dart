import 'dart:developer';

import 'package:pos_system/features/sales/data/model/sales_model.dart';
import 'package:pos_system/features/sales/data/repository/offline_database/sales_database_helper.dart';
import 'package:pos_system/features/sales/data/repository/offline_database/my_salesmodel_converters.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline_sales.g.dart';

@Riverpod(keepAlive: true)
class MyOfflineSales extends _$MyOfflineSales {
  @override
  Future<List<SalesModel>> build() async {
    await checkForUnregisteredSales();
    return await getAllSales();
  }

  /// Check Firebase for unregistered to offline sales db
  Future<void> checkForUnregisteredSales() async {
    final offlineSavedSalesData = await getAllSales();
    final salesRepo = ref.read(salesRepoProvider);
    List<SalesModel> tempRetrievedSales = [];

    if (offlineSavedSalesData.isEmpty) {
      log("OFFLINE sales table is empty. Syncing all remote records...");
      tempRetrievedSales = await salesRepo.getAllRecords();
    } else {
      // Get the newest sale's dateTime. (Since getAllSales sorts descending, index 0 is newest)
      String lastRegisteredDateTime = offlineSavedSalesData.first.dateTime;

      // Query Firebase for sales newer than lastRegisteredDateTime
      final snapshot = await salesRepo.collection
          .where('dateTime', isGreaterThan: lastRegisteredDateTime)
          .get();

      tempRetrievedSales = snapshot.docs.map((doc) {
        return salesRepo.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    }

    // Save remote sales data offline
    if (tempRetrievedSales.isNotEmpty) {
      for (var sale in tempRetrievedSales) {
        await insertSales(sale);
        log("inserted to OFFLINE sales table: ${sale.id}");
      }
    } else {
      log("OFFLINE sales table is up to date!");
    }
  }

  Future<List<SalesModel>> getAllSales() async {
    final salesDB = await DatabaseHelper().database;
    List<Map> tempSalesQuery = await salesDB.query('sales');
    List<SalesModel> sales = tempSalesQuery.map((sale) {
      return mySalesModelFromJsonConverter(sale);
    }).toList();

    sales.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sales;
  }

  Future<int> insertSales(SalesModel sales) async {
    final salesDB = await DatabaseHelper().database;
    return await salesDB.insert('sales', mySalesModelToMapConverter(sales));
  }

  Future<List<SalesModel>> getRecordsBaseOnTimeSpan({
    required String fromTheTime,
    required String untilTheTime,
  }) async {
    final salesDB = await DatabaseHelper().database;
    final query = await salesDB.query(
      'sales',
      where: 'dateTime BETWEEN ? AND ?',
      whereArgs: [fromTheTime, untilTheTime],
    );

    List<SalesModel> sales = query.map((sale) {
      return mySalesModelFromJsonConverter(sale);
    }).toList();

    log(
      "The number of Offline Sales data retrieved from getRecordsBaseOnTimeSpan(): ${sales.length}",
    );

    return sales;
  }
}
