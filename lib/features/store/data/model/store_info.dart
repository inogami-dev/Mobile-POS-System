import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_system/core/models/base_entity.dart';

part 'store_info.freezed.dart';
part 'store_info.g.dart';

@Freezed()
class StoreInfo with _$StoreInfo implements BaseEntity {
  const StoreInfo._();

  const factory StoreInfo({
    String? id,
    required String storeName,
    required String storeOwner,
    required String picture,
    required String registeredOn,
    required String registeredBy,
  }) = _StoreInfo;

  factory StoreInfo.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoFromJson(json);
}
