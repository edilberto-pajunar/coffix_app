import 'package:coffix_app/features/order/data/model/order.dart';

abstract class OrderRepository {
  Stream<List<Order>> getOrders();
}