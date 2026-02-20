import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/data/repositories/store_repository.dart';
import 'package:coffix_app/features/stores/data/model/store.dart';

class StoreRepositoryImpl implements StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Stream<List<Store>> getStores() {
    return _firestore.collection('stores').snapshots().map((event) {
      return event.docs.map((doc) => Store.fromJson(doc.data())).toList();
    });
  }
}
