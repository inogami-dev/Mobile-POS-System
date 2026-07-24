import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_system/core/models/base_entity.dart';

part 'scanned_item.g.dart';
part 'scanned_item.freezed.dart';

@Freezed()
class ScannedItem with _$ScannedItem implements BaseEntity {
  const ScannedItem._();

  const factory ScannedItem({
    String? id,
    required String name,
    required double quantity,
    required double price,
  }) = _ScannedItem;

  factory ScannedItem.fromJson(Map<String, dynamic> json) =>
      _$ScannedItemFromJson(json);
}
