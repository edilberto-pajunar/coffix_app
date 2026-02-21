import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/app_repository.dart';
import 'package:coffix_app/features/app/data/model/global.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.dart';
part 'app_cubit.freezed.dart';

class AppCubit extends Cubit<AppState> {
  final AppRepository _appRepository;
  AppCubit({required AppRepository appRepository})
    : _appRepository = appRepository,
      super(AppState.initial());

  Future<void> getGlobal() async {
    emit(AppState.loading());
    try {
      final global = await _appRepository.getGlobal();
      emit(AppState.loaded(global: global));
    } catch (e) {
      emit(AppState.error(message: e.toString()));
    }
  }
}
