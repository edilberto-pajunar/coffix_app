import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:coffix_app/core/utils/time_utils.dart';
import 'package:coffix_app/data/repositories/order_repository.dart';
import 'package:coffix_app/features/order/data/model/order.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OrderRepositoryImpl();

  @override
  Stream<List<Order>> getOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not found');
    }
    return _firestore
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .where(
          'status',
          whereNotIn: [
            OrderStatus.draft.name,
            OrderStatus.pendingPayment.name,
            OrderStatus.pending.name,
          ],
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
          return event.docs.map((doc) => Order.fromJson(doc.data())).toList();
        });
  }

  @override
  Future<void> updateOrder({required Map<String, dynamic> data}) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not found');
    }
    await _firestore.collection('orders').doc(data['id']).set({
      ...data,
      "updatedAt": TimeUtils.now(),
    }, SetOptions(merge: true));
  }
}
