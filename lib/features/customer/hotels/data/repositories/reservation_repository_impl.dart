import '../../domain/repositories/reservation_repository.dart';
import '../datasources/reservation_remote_data_source.dart';
import '../models/reservation_models.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  const ReservationRepositoryImpl(this._dataSource);

  final ReservationRemoteDataSource _dataSource;

  @override
  Future<ReservationResponse> createReservation(ReservationRequest request) {
    return _dataSource.createReservation(request);
  }

  @override
  Future<List<ReservationResponse>> getMyReservations() {
    return _dataSource.getMyReservations();
  }

  @override
  Future<ReservationResponse> getReservationById(String id) {
    return _dataSource.getReservationById(id);
  }
}
