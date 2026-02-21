import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffix_app/data/repositories/auth_repository.dart';
import 'package:coffix_app/data/repositories/store_repository.dart';
import 'package:coffix_app/features/auth/data/model/user.dart';
import 'package:coffix_app/features/auth/data/model/user_with_store.dart';
import 'package:coffix_app/features/stores/data/model/store.dart';
import 'package:rxdart/rxdart.dart';

class StoreRepositoryImpl implements StoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepository _authRepository;

  StoreRepositoryImpl({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Stream<List<Store>> getStores() {
    return _firestore.collection('stores').snapshots().map((event) {
      return event.docs.map((doc) => Store.fromJson(doc.data())).toList();
    });
  }

  @override
  Stream<Store> getPreferredStore({required String storeId}) {
    return _firestore.collection('stores').doc(storeId).snapshots().map((
      event,
    ) {
      return event.exists
          ? Store.fromJson(event.data() ?? {})
          : throw Exception('Store not found');
    });
  }

  @override
  Stream<AppUserWithStore?> getUserWithStore() {
    final userStream = _authRepository.getUser();
    return userStream.switchMap((user) {
      final String? storeId = user?.preferredStoreId;
      if (storeId == null || storeId.isEmpty) {
        return Stream.value(AppUserWithStore(user: user!, store: null));
      }

      return Rx.combineLatest2<AppUser, Store, AppUserWithStore>(
        Stream.value(user!),
        getPreferredStore(storeId: storeId),
        (user, stores) {
          return AppUserWithStore(user: user, store: stores);
        },
      );
    });
  }
}
