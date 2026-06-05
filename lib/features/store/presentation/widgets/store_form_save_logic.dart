import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pos_system/core/constants/app_collections.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/features/account/data/repository/personal_info_repository.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/data/repository/store_info_repository.dart';

void saveToFirebase({
  required MyPersonalInfoRepository personalInfoRepo,
  // required String personalInfoID,
  required String storeName,
  required String storeOwner,
  required String picture,
}) {
  StoreInfoRepository storeRepo = StoreInfoRepository(
    collectionPath: MyAppCollections.store,
  );

  try {
    storeRepo.add(
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
