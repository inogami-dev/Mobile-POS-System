import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_system/core/models/base_entity.dart';

part 'sales_model.g.dart';
part 'sales_model.freezed.dart';

@Freezed()
class SalesModel with _$SalesModel implements BaseEntity {
  factory SalesModel({
    String? id,

    /// The elements in [particulars] is a String containing productID and quantity
    /// combined separated by colon. Example: "productID:4"
    required List<String> particulars,
    required double totalAmount,
    required double payment,
    required double change,
    required String dateTime,
    required String cashierId,
  }) = _SalesModel;

  factory SalesModel.fromJson(Map<String, dynamic> json) =>
      _$SalesModelFromJson(json);
}
