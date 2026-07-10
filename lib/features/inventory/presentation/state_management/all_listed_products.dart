import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_listed_products.g.dart';

@Riverpod()
class AllListedProducts extends _$AllListedProducts {
  @override
  Future<List<ProductModel>> build() async {
    final currentSelectedStoreID = ref
        .read(currentLoggedInUserControllerProvider)
        .value!
        .currentStoreInView;

    final productRepository = ref.read(
      productRepositoryProvider(currentSelectedStoreID),
    );
    final products = await productRepository.getAllRecords();
    products.sort((a, b) => a.queryName.compareTo(b.queryName));
    return products;
  }
}
