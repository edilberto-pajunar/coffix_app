import 'package:coffix_app/core/flavors/flavor_config.dart';

abstract class ApiEndpoints {
  static String baseUrl = FlavorConfig.instance.baseUrl;
}
