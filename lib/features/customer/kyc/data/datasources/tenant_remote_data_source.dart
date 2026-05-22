import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import 'package:statefulclickcounter/features/auth/data/models/api_response.dart';
import '../models/tenant_models.dart';

class TenantRemoteDataSource {
  TenantRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UploadResult> uploadDocument(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: file.name,
        ),
      });

      final response = await _dio.post(
        ApiEndpoints.storageUpload,
        queryParameters: {'bucket': 'tenant-documents'},
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final api = ApiResponse<UploadResult>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => UploadResult.fromJson(json! as Map<String, dynamic>),
      );
      final data = api.data;
      if (data == null) {
        throw ApiException(message: 'Upload échoué', statusCode: api.statusCode);
      }
      return data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<TenantProfile> createProfile(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.tenantProfile,
        data: body,
      );
      return _parseTenant(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<TenantProfile> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.tenantProfile);
      return _parseTenant(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<TenantProfile> updateProfile(Map<String, dynamic> body) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.tenantProfile,
        data: body,
      );
      return _parseTenant(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  TenantProfile _parseTenant(Map<String, dynamic> envelope) {
    final raw = envelope['data'];
    if (raw is Map<String, dynamic>) {
      return TenantProfile.fromJson(raw);
    }
    throw ApiException(message: 'Réponse invalide du serveur');
  }
}
