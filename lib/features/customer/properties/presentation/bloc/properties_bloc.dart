import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statefulclickcounter/core/network/error_handler.dart';

import '../../domain/repositories/properties_repository.dart';
import 'properties_event.dart';
import 'properties_state.dart';

class PropertiesBloc extends Bloc<PropertiesEvent, PropertiesState> {
  PropertiesBloc(this._repository) : super(const PropertiesState.initial()) {
    on<PropertiesStarted>(_onLoad);
    on<PropertiesRefreshed>(_onLoad);
  }

  final PropertiesRepository _repository;

  Future<void> _onLoad(PropertiesEvent event, Emitter<PropertiesState> emit) async {
    final int page;
    final int perPage;

    if (event is PropertiesStarted) {
      page = event.page;
      perPage = event.perPage;
    } else if (event is PropertiesRefreshed) {
      page = event.page;
      perPage = event.perPage;
    } else {
      page = 0;
      perPage = 20;
    }

    emit(state.copyWith(status: PropertiesStatus.loading, message: null));
    try {
      final res = await _repository.getProperties(page: page, perPage: perPage);
      emit(
        state.copyWith(
          status: PropertiesStatus.loaded,
          items: res.results,
          message: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PropertiesStatus.error,
          message: AppErrors.translate(e),
        ),
      );
    }
  }
}
