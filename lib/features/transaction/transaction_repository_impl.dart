import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/data/repositories/transaction_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffix_app/features/transaction/data/model/transaction.dart'
    as ts;

class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<List<ts.Transaction>> getTransactions() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not found');
    }
    final snapshot = await _firestore
        .collection('transactions')
        .where("customerId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs
        .map((doc) => ts.Transaction.fromJson(doc.data()))
        .toList();
  }
}
