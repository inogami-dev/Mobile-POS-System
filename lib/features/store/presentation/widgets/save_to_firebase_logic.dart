import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/features/account/data/repository/personal_info_repository.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/presentation/state_management/store_info_controller.dart';

void saveToFirebase({
  required WidgetRef ref,
  required MyPersonalInfoRepository personalInfoRepo,
  // required String personalInfoID,
  required String storeName,
  required String storeOwner,
  required String picture,
}) {
  // StoreInfoRepository storeRepo = StoreInfoRepository(
  //   collectionPath: MyAppCollections.store,
  // );
  final storeRepoRef = ref.read(storeInfoRepoRefProvider);

  try {
    storeRepoRef.add(
      StoreInfo(
        storeName: storeName,
        storeOwner: storeOwner,
        picture: picture,
        registeredOn: MyDateFormatter.formatDate(
          dateTimeInString: DateTime.now(),
        ),
        registeredBy: FirebaseAuth.instance.currentUser!.uid,
      ),
    );

    // To be continued
    // personalInfoRepo.update(personalInfoID,);

    log("Successfully saved to Firebase!");
  } catch (e, stackTrace) {
    log("Error: $e");
    log("Stack Trace: $stackTrace");
  }
}
