import 'package:pos_system/features/account/domain/base_repository.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';

class StoreInfoRepository extends BaseRepository<StoreInfo> {
  StoreInfoRepository({required super.collectionPath});

  @override
  StoreInfo fromMap(Map<String, dynamic> map, String id) {
    return StoreInfo.fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(StoreInfo store) {
    return store.toJson();
  }
}
