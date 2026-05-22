import '../../domain/repositories/agencies_repository.dart';
import '../datasources/agencies_remote_data_source.dart';
import '../models/agency_models.dart';

class AgenciesRepositoryImpl implements AgenciesRepository {
  AgenciesRepositoryImpl(this._remote);

  final AgenciesRemoteDataSource _remote;

  @override
  Future<AgenciesPage> getAgencies({
    String? city,
    String? country,
    String? region,
    String? zone,
    int page = 0,
    int size = 20,
  }) {
    return _remote.getAgencies(
      city: city,
      country: country,
      region: region,
      zone: zone,
      page: page,
      size: size,
    );
  }
}
