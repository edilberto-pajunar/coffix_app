import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/internet_connection_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'network_state.dart';
part 'network_cubit.freezed.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final InternetConnectionService _internetService;
  StreamSubscription<InternetStatus>? _subscription;

  NetworkCubit({required InternetConnectionService internetService})
    : _internetService = internetService,
      super(const NetworkState.connected()) {
    _subscription = _internetService.onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        emit(const NetworkState.connected());
      } else {
        emit(const NetworkState.disconnected());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
