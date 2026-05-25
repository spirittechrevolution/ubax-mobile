import '../../data/models/property_models.dart';

abstract class PropertiesRepository {
  Future<PropertiesPage> getProperties({
    int page = 0,
    int perPage = 20,
    String? type,
    String? city,
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    bool? boosted,
  });

  Future<PropertyItem> getPropertyById(String propertyId);

  Future<PropertyDetailResponse> getPropertyDetails(String propertyId);
}
