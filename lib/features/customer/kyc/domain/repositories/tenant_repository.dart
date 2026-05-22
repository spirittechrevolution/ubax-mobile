import 'package:image_picker/image_picker.dart';
import '../../data/models/tenant_models.dart';

abstract class TenantRepository {
  Future<UploadResult> uploadDocument(XFile file);

  /// Returns null if the user has no profile yet (404).
  Future<TenantProfile?> getProfile();

  Future<TenantProfile> createProfile(Map<String, dynamic> body);

  Future<TenantProfile> updateProfile(Map<String, dynamic> body);
}
