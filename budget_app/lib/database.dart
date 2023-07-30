import 'dart:math';
import 'package:budget_app/entries.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({required this.uid});
  //collection reference
  final CollectionReference expenseCollection=FirebaseFirestore.instance.collection('expenses');

  Future<void> addEntry(String category, int price) async {
    try {
      await expenseCollection.doc(uid).collection('user_entries').add({
        'category': category,
        'price': price,
      });
    } catch (e) {
      // Handle any errors that occur during data writing
      print('Error adding entry: $e');
    }
  }

  Future updateUserData(String category,int price)async{
    return await expenseCollection.doc(uid).collection('user_entries').add(
      {
        'category': category,
        'price': price
      }
    );
  }

  Future<void> deleteEntry(String category, int price) async {
    try {
      QuerySnapshot querySnapshot = await expenseCollection
          .doc(uid)
          .collection('user_entries')
          .where('category', isEqualTo: category)
          .where('price', isEqualTo: price)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await expenseCollection.doc(uid).collection('user_entries').doc(docId).delete();
      }
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting entry: $e');
    }
  }

  //expenses list from snapshot

  List<Entry> _expensesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>?
      return Entry(
        category: data?['category'] as String? ?? '',
        price: data?['price'] as int? ?? 0,
      );
    }).toList();
  }

  //get expenses stream
  Stream<List<Entry>> get expenses{
    return expenseCollection.snapshots().map(_expensesListFromSnapshot);
  }

}