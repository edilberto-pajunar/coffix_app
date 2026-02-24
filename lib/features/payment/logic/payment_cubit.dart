import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/payment_repository.dart';
import 'package:coffix_app/features/payment/data/model/payment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.dart';
part 'payment_cubit.freezed.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;
  PaymentCubit({required PaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository,
      super(PaymentState.initial());

  void createPayment({required PaymentRequest request}) async {
    emit(PaymentState.loading());
    try {
      final paymentUrl = await _paymentRepository.createPaymentSession(
        request: request,
      );
      emit(PaymentState.loaded(paymentUrl: paymentUrl));
    } catch (e) {
      emit(PaymentState.error(message: e.toString()));
    }
  }
}
