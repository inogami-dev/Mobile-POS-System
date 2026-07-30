import 'package:pos_system/features/account/domain/base_repository.dart';
import 'package:pos_system/features/sales/data/model/sales_model.dart';

class SalesRepository extends BaseRepository<SalesModel> {
  SalesRepository() : super(collectionPath: "Sales");

  @override
  SalesModel fromMap(Map<String, dynamic> map, String id) {
    return SalesModel.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(SalesModel item) {
    return item.toJson();
  }
}
