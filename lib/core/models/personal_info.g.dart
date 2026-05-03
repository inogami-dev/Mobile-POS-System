// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PersonalInfo _$$_PersonalInfoFromJson(Map<String, dynamic> json) =>
    _$_PersonalInfo(
      userID: json['userID'] as String,
      name: json['name'] as String,
      ownerAt:
          (json['ownerAt'] as List<dynamic>).map((e) => e as String).toList(),
      staffAt:
          (json['staffAt'] as List<dynamic>).map((e) => e as String).toList(),
      customerAt: (json['customerAt'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      picture: json['picture'] as String,
      address: json['address'] as String,
      registeredOn: json['registeredOn'] as String,
      email: json['email'] as String,
      sex: json['sex'] as String,
      age: json['age'] as String,
      contactNumber: json['contactNumber'] as String,
      creditBalance: (json['creditBalance'] as num?)?.toDouble() ?? 0.0,
      registeredBy: json['registeredBy'] as String? ?? "",
    );

Map<String, dynamic> _$$_PersonalInfoToJson(_$_PersonalInfo instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'name': instance.name,
      'ownerAt': instance.ownerAt,
      'staffAt': instance.staffAt,
      'customerAt': instance.customerAt,
      'picture': instance.picture,
      'address': instance.address,
      'registeredOn': instance.registeredOn,
      'email': instance.email,
      'sex': instance.sex,
      'age': instance.age,
      'contactNumber': instance.contactNumber,
      'creditBalance': instance.creditBalance,
      'registeredBy': instance.registeredBy,
    };
