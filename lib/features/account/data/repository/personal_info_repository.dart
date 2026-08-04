import 'package:pos_system/core/constants/app_collections.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/domain/base_repository.dart';

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
}
