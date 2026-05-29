import 'package:pos_system/core/constants/app_collections.dart';
import 'package:pos_system/core/models/personal_info/personal_info.dart';
import 'package:pos_system/core/repository/repository.dart';

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
