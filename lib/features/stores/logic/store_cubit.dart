import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/store_repository.dart';
import 'package:coffix_app/features/stores/data/model/store.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_state.dart';
part 'store_cubit.freezed.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository _storeRepository;
  StreamSubscription<List<Store>>? _storesSubscription;

  StoreCubit({required StoreRepository storeRepository})
    : _storeRepository = storeRepository,
      super(StoreState.initial());

  void getStores() {
    emit(StoreState.loading());
    _storesSubscription?.cancel();
    _storesSubscription = _storeRepository.getStores().listen(
      (stores) => emit(StoreState.loaded(stores: stores)),
      onError: (e) => emit(StoreState.error(message: e.toString())),
    );
  }
}
