import 'package:pos_system/features/account/domain/base_repository.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class ProductRepository extends BaseRepository<ProductModel> {
  ProductRepository() : super(collectionPath: 'Products');

  @override
  ProductModel fromMap(Map<String, dynamic> map, String id) {
    return ProductModel.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(ProductModel item) {
    return item.toJson();
  }
}
