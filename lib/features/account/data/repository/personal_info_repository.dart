import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/constants/app_collections.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/data/repository/base_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'personal_info_repository.g.dart';

class MyPersonalInfoRepository extends BaseRepository<PersonalInfo> {
  MyPersonalInfoRepository()
    : super(collectionPath: MyAppCollections.personalInfo);

  @override
  PersonalInfo fromMap(Map<String, dynamic> map, String id) {
    return PersonalInfo.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(PersonalInfo item) {
    return item.toJson();
  }

  Future<List<PersonalInfo>> getAllPersonalInfo() async {
    try {
      List<PersonalInfo> personalInfoList = [];
      QuerySnapshot snapshot = await collection.get();
      for (var doc in snapshot.docs) {
        personalInfoList.add(
          fromMap(doc.data() as Map<String, dynamic>, doc.id),
        );
      }
      return personalInfoList;
    } catch (e) {
      rethrow;
    }
  }

  // Future<PersonalInfo?> getSpecificPersonalInfo({
  //   required String userID,
  // }) async {
  //   try {
  //     // 1. Try to find by userID field
  //     List<PersonalInfo> results = await getByID(
  //       id: userID,
  //       lookForField: 'userID',
  //       lookForValue: userID,
  //     );

  //     // 2. If empty, try searching by deviceID
  //     if (results.isEmpty) {
  //       results = await getByID(
  //         id: userID,
  //         lookForField: 'deviceID',
  //         lookForValue: userID,
  //       );
  //     }

  //     return results.firstOrNull;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> uploadProfilePicture({
  //   required String userID,
  //   required String base64Image,
  // }) async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await collection.where('userID', isEqualTo: userID).limit(1).get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       await collection.doc(querySnapshot.docs.first.id).update({
  //         "picture": base64Image,
  //       });
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}

@riverpod
MyPersonalInfoRepository myPersonalInfoRepository(Ref ref) {
  // This tells Riverpod: "When someone asks for this provider,
  // create ONE instance of my repository and give it to them."
  return MyPersonalInfoRepository();
}
