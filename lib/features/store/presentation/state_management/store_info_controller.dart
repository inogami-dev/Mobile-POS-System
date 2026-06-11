import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/data/repository/store_info_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_info_controller.g.dart';

@riverpod
class StoreInfoRepoController extends _$StoreInfoRepoController {
  StoreInfo build() {
    final currentlyLoggedInUser = ref.read(
      currentLoggedInUserControllerProvider,
    );

    // Setup the store
    if (currentlyLoggedInUser.value != null) {
      String storeID = currentlyLoggedInUser.value!.currentStoreInView;
      setCurrentStore(storeID);
    }

    return StoreInfo(
      storeName: '',
      storeOwner: '',
      picture: '',
      registeredOn: '',
      registeredBy: '',
    );
  }

  /// Change the current store view
  Future<void> setCurrentStore(String storeID) async {
    try {
      final store = await ref.read(storeInfoRepoRefProvider).getByID(storeID);
      state = store!;
    } catch (e, stackTrace) {
      log("Error: $e");
      log("Stack Trace: $stackTrace");
      rethrow;
    }
    ;
  }

  Future<List<StoreInfo>> userStores() async {
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
}

// Repo
@riverpod
StoreInfoRepository storeInfoRepoRef(Ref ref) {
  return StoreInfoRepository();
}
