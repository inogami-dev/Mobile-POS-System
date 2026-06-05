import 'package:firebase_auth/firebase_auth.dart';

class MyAppCollections {
  MyAppCollections._(); // private constructor to prevent instantiation
  static String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

  static const String personalInfo = "Personal Info";
  static const String products = 'Products';
  // static const String transactionsCollection = 'transactions';
  // static const String utangCollection = 'utang';
  // static const String accountsCollection = 'accounts';
  static const String store = 'Store';
}
