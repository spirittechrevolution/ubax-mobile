import '../../domain/repositories/properties_repository.dart';
import '../datasources/properties_remote_data_source.dart';
import '../models/property_models.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  PropertiesRepositoryImpl(this._remote);

  final PropertiesRemoteDataSource _remote;

  @override
  Future<PropertiesPage> getProperties({
    int page = 0,
    int perPage = 20,
    String? type,
    String? city,
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    bool? boosted,
  }) {
    return _remote.getProperties(
      page: page,
      perPage: perPage,
      type: type,
      city: city,
      minPrice: minPrice,
      maxPrice: maxPrice,
      bedrooms: bedrooms,
      boosted: boosted,
    );
  }

  @override
  Future<PropertyItem> getPropertyById(String propertyId) {
    return _remote.getPropertyById(propertyId);
  }

  @override
  Future<PropertyDetailResponse> getPropertyDetails(String propertyId) {
    return _remote.getPropertyDetails(propertyId);
  }
}
