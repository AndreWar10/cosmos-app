import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/planet_info.dart';
import '../../domain/usecases/get_planet_info_usecase.dart';

sealed class PlanetDetailState {}

class PlanetDetailInitial extends PlanetDetailState {}

class PlanetDetailLoading extends PlanetDetailState {}

class PlanetDetailLoaded extends PlanetDetailState {
  PlanetDetailLoaded(this.info);
  final PlanetInfo info;
}

class PlanetDetailError extends PlanetDetailState {}

class PlanetDetailCubit extends Cubit<PlanetDetailState> {
  PlanetDetailCubit(this._getPlanetInfoUseCase) : super(PlanetDetailInitial());

  final GetPlanetInfoUseCase _getPlanetInfoUseCase;

  Future<void> load(String planetName) async {
    emit(PlanetDetailLoading());
    try {
      final info = await _getPlanetInfoUseCase(planetName);
      if (info != null) {
        emit(PlanetDetailLoaded(info));
      } else {
        emit(PlanetDetailError());
      }
    } catch (_) {
      emit(PlanetDetailError());
    }
  }
}
