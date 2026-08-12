import '../entities/apod.dart';
import '../repositories/home_repository.dart';

class GetApodUseCase {
  const GetApodUseCase(this._repository);

  final HomeRepository _repository;

  Future<Apod> call() => _repository.getApod();
}
