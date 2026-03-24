import 'package:coffix_app/core/flavors/flavor_config.dart';

class AppConstants {
  static String get databaseId => FlavorConfig.instance.flavor == Flavor.dev
      ? 'coffix-app-dev'
      : 'coffix-prod-australia';
}
