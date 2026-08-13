import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/planet_info.dart';
import '../../../home/domain/usecases/get_planet_info_usecase.dart';

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

  void load(String planetKey) {
    final info = _getPlanetInfoUseCase(planetKey);
    if (info != null) {
      emit(PlanetDetailLoaded(info));
    } else {
      emit(PlanetDetailError());
    }
  }
}
