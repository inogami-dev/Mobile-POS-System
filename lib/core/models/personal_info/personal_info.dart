import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_info.freezed.dart';
part 'personal_info.g.dart';

// @freezed
@Freezed()
class PersonalInfo with _$PersonalInfo {
  const PersonalInfo._();

  const factory PersonalInfo({
    required String userID,
    required String name,
    // @Default("No Role") String role,
    required List<String> ownerAt,
    required List<String> staffAt,
    required List<String> customerAt,
    required String picture,
    required String address,
    required String registeredOn,
    required String email,
    required String sex,
    required String age,
    required String contactNumber,

    /// For customer role only
    @Default(0.0) double creditBalance,
    @Default("") String registeredBy,
  }) = _PersonalInfo;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);
}
