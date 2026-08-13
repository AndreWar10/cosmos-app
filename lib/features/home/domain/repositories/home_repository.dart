import '../entities/apod.dart';

abstract class HomeRepository {
  Future<Apod> getApod({String? date});
}
