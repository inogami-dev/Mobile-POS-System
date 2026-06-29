import 'package:pos_system/features/products/data/repository/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repo_ref_controller.g.dart';

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref, String storeID) {
  return ProductRepository(storeID: storeID);
}
