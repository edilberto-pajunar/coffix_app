import 'package:coffix_app/core/flavors/flavor_config.dart';
import 'package:coffix_app/main_common.dart';

void main() {
  mainCommon(
    flavor: Flavor.prod,
    baseUrl: 'https://api.coffix.com',
    name: 'Coffix',
  );
}
