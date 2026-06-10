import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/presentation/state_management/store_info_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_stores_controller.g.dart';

// @riverpod
// class UserStoresController extends _$UserStoresController {
//   @override
//   Future<List<StoreInfo>> build() {
//     ;
//   }
// }

@riverpod
Future<List<StoreInfo>> userStores(Ref ref) async {
  // 1. Wait for the user to be fully loaded
  final user = await ref.watch(currentLoggedInUserControllerProvider.future);
  if (user == null) return [];

  // 2. Combine all their store IDs
  final allStoreIds = [...user.ownerAt, ...user.staffAt, ...user.customerAt];
  if (allStoreIds.isEmpty) return [];

  // 3. Fetch the StoreInfo for each ID
  final storeRepo = ref.watch(storeInfoRepoRefProvider);
  List<StoreInfo> stores = [];

  for (String id in allStoreIds) {
    final store = await storeRepo.getByID(id);
    if (store != null) stores.add(store);
  }

  return stores;
}
