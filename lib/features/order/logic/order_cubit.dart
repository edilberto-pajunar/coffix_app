import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_state.dart';
part 'order_cubit.freezed.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState.initial());
}
