import 'package:coffix_app/features/auth/data/model/user_with_store.dart';
import 'package:coffix_app/features/stores/data/model/store.dart';

abstract class StoreRepository {
  Stream<List<Store>> getStores();
  Stream<Store> getPreferredStore({required String storeId});
  Stream<AppUserWithStore?> getUserWithStore();
}
