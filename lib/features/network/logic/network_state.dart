part of 'network_cubit.dart';

@freezed
class NetworkState with _$NetworkState {
  const factory NetworkState.connected() = _Connected;
  const factory NetworkState.disconnected() = _Disconnected;
}
