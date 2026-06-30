import 'package:pos_system/core/models/base_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@Freezed()
class ProductModel with _$ProductModel implements BaseEntity {
  const ProductModel._();

  const factory ProductModel({
    String? id,
    required String name,
    required String storeId,
    required String description,
    required String barCode,
    required double price,
    required int quantity,
    required String picture,
    required String expirationDate,
    required String registeredOn,
    required String registeredBy,
    // required int stock,
    // required String category,
    // required String imageUrl,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
