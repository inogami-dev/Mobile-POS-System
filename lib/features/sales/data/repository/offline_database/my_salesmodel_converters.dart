import 'dart:convert';

import 'package:pos_system/features/sales/data/model/sales_model.dart';

Map<String, dynamic> mySalesModelToMapConverter(SalesModel sales) {
  // List<String> particularsList = sales.particulars;
  String jsonString = jsonEncode(sales.particulars);

  return {
    'particulars': jsonString,
    'totalAmount': sales.totalAmount,
    'payment': sales.payment,
    'change': sales.change,
    'dateTime': sales.dateTime,
    'cashierId': sales.cashierId,
  };
}

SalesModel mySalesModelFromJsonConverter(Map<String, dynamic> json) {
  // return SalesModel.fromJson(
  //   json
  // );
  // Converts the string back into a Dart List
  List<dynamic> decodedList = jsonDecode(json['particulars']);
  List<String> finalHobbiesList = List<String>.from(decodedList);

  return SalesModel(
    particulars: finalHobbiesList,
    totalAmount: json['totalAmount'],
    payment: json['payment'],
    change: json['change'],
    dateTime: json['dateTime'],
    cashierId: json['cashierId'],
  );
}
