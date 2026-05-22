import '../../data/models/agency_models.dart';

abstract class AgenciesRepository {
  Future<AgenciesPage> getAgencies({
    String? city,
    String? country,
    String? region,
    String? zone,
    int page = 0,
    int size = 20,
  });
}
