import 'package:bloc/bloc.dart';

class ScheduleCubit extends Cubit<DateTime?> {
  ScheduleCubit() : super(null);

  void setPickupAt(DateTime dateTime) => emit(dateTime);
}
