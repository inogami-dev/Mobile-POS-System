import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_system/core/models/base_entity.dart';

abstract class BaseRepository<T extends BaseEntity> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath;

  BaseRepository({required this.collectionPath});

  CollectionReference get collection => _firestore.collection(collectionPath);

  // Create the document then get its ID, so that we have the document name (id) same as the field id value
  DocumentReference _generateDocID([String? id]) {
    return collection.doc(id);
  }

  // ----------------------- Transformers ------------------

  Map<String, dynamic> toMap(T item);
  T fromMap(Map<String, dynamic> map, String id);

  //------------------------ CRUD Operations Para di libog ------------------
  // Create -------------------------------------------------
  Future<void> add(T item) async {
    try {
      DocumentReference docRef = _generateDocID(item.id);
      // await collection.add(toMap(item));

      Map items = toMap(item);
      items['id'] = docRef.id;
      docRef.set(items);
    } catch (e, stackTrace) {
      log("Error adding data: $e\n$stackTrace");
      rethrow;
    }
  }

  // Read -------------------------------------------------

  // RESPONSIBILITY 1: Get a single document by its exact ID
  Future<T?> getByID(String id) async {
    try {
      DocumentSnapshot snapshot = await collection.doc(id).get();
      if (snapshot.exists && snapshot.data() != null) {
        return fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        log("Document with ID $id does not exist in $collectionPath");
        return null; // Return null instead of an empty list for a single item request
      }
    } catch (e, stackTrace) {
      log("Error fetching data by ID: $e\n$stackTrace");
      rethrow;
    }
  }

  // RESPONSIBILITY 2: Query the collection for multiple documents
  Future<List<T>> getByQuery({
    required String field,
    required dynamic value,
  }) async {
    try {
      QuerySnapshot querySnapshot = await collection
          .where(field, isEqualTo: value)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) {
          return fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      } else {
        log("No documents found in $collectionPath where $field equals $value");
        return [];
      }
    } catch (e, stackTrace) {
      log("Error fetching data by query: $e\n$stackTrace");
      rethrow;
    }
  }

  Future<List<T>> getAllRecords() async {
    try {
      List<T> records = [];
      QuerySnapshot snapshot = await collection.get();
      for (var doc in snapshot.docs) {
        records.add(fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      return records;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> doesThisRecordExist({required String recordID}) async {
    // final doc = await collection.where('id', isEqualTo: userID).limit(1);

    final doc = await collection.doc(recordID).get();

    return doc.exists;
  }

  // Update -------------------------------------------------
  Future<void> update(String id, T item) async {
    log("SUCCESSFUL UPDATE");
    await collection.doc(id).update(toMap(item));
  }

  // Delete --------------------------------------------------
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }
}
