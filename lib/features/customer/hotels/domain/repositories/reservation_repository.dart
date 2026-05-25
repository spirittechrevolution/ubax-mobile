import '../../data/models/reservation_models.dart';

abstract interface class ReservationRepository {
  Future<ReservationResponse> createReservation(ReservationRequest request);
  Future<List<ReservationResponse>> getMyReservations();
  Future<ReservationResponse> getReservationById(String id);
}
