import 'package:coffix_app/core/flavors/flavor_config.dart';
import 'package:coffix_app/main_common.dart';

void main() {
  mainCommon(
    flavor: Flavor.dev,
    baseUrl: 'https://api.coffix.dev',
    name: 'Coffix Dev',
  );
}
