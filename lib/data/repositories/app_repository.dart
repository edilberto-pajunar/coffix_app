import 'package:coffix_app/features/app/data/model/global.dart';

abstract class AppRepository {
  Future<AppGlobal> getGlobal();
}