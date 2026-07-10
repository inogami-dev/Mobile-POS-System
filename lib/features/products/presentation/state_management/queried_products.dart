import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queried_products.g.dart';

@riverpod
class QueriedProducts extends _$QueriedProducts {
  @override
  List<ProductModel> build() {
    return [];
  }

  void setQueriedProducts(List<ProductModel> query) {
    state = query;
  }

  void resetQueryState() {
    state = [];
  }
}
