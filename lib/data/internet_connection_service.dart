import 'package:coffix_app/core/api/model/endpoints.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  late final InternetConnection _connection;

  InternetConnectionService() {
    _connection = InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse('${ApiEndpoints.endpoint}/health')),
      ],
    );
  }

  Future<bool> get hasInternetAccess => _connection.hasInternetAccess;

  Stream<InternetStatus> get onStatusChange => _connection.onStatusChange;
}
