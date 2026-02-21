import 'package:coffix_app/features/modifier/data/model/modifier.dart';
import 'package:coffix_app/features/modifier/data/model/modifier_group_bundle.dart';
import 'package:coffix_app/features/modifier/data/model/modifier_group.dart';
import 'package:coffix_app/features/products/data/model/product.dart';

abstract class ModifierRepository {
  Future<List<ModifierGroup>> getModifierGroups({
    required List<String> groupIds,
  });
  Future<List<Modifier>> getModifiersByIds({required List<String> modifierIds});

  /// Runs Steps 2–7: store override, enabled groups, fetch groups, fetch modifiers, build bundles in order.
  Future<List<ModifierGroupBundle>> getCustomizationBundles({
    required String storeId,
    required Product product,
  });
}
