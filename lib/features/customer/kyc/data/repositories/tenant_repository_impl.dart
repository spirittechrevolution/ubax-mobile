import 'package:image_picker/image_picker.dart';

import 'package:statefulclickcounter/core/network/api_exception.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../datasources/tenant_remote_data_source.dart';
import '../models/tenant_models.dart';

class TenantRepositoryImpl implements TenantRepository {
  TenantRepositoryImpl(this._ds);

  final TenantRemoteDataSource _ds;

  @override
  Future<UploadResult> uploadDocument(XFile file) => _ds.uploadDocument(file);

  @override
  Future<TenantProfile?> getProfile() async {
    try {
      return await _ds.getProfile();
    } on ApiException catch (e) {
      if (e.isNotFound) return null;
      rethrow;
    }
  }

  @override
  Future<TenantProfile> createProfile(Map<String, dynamic> body) =>
      _ds.createProfile(body);

  @override
  Future<TenantProfile> updateProfile(Map<String, dynamic> body) =>
      _ds.updateProfile(body);
}
