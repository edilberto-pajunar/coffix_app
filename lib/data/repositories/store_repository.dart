import 'package:coffix_app/features/stores/data/model/store.dart';

abstract class StoreRepository {
  Stream<List<Store>> getStores();
}