import 'package:pos_system/features/sales/data/model/sales_model.dart';
import 'package:pos_system/features/sales/data/repository/offline_database/sales_database_helper.dart';
import 'package:pos_system/features/sales/data/repository/offline_database/my_salesmodel_converters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline_sales.g.dart';

@Riverpod(keepAlive: true)
class MyOfflineSales extends _$MyOfflineSales {
  @override
  Future<List<SalesModel>> build() async {
    return [];
  }

  Future<List<SalesModel>> _getAllUnregisteredSales() async {
    final salesDB = await DatabaseHelper().database;

    return [];
  }

  Future<int> insertSales(SalesModel sales) async {
    final salesDB = await DatabaseHelper().database;
    return await salesDB.insert('sales', mySalesModelToMapConverter(sales));
  }

  // Future<SalesModel>
}
