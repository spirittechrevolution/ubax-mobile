import 'package:dio/dio.dart';

import 'package:statefulclickcounter/core/constants/api_endpoints.dart';
import 'package:statefulclickcounter/core/network/api_exception.dart';
import 'package:statefulclickcounter/features/auth/data/models/api_response.dart';

import '../models/bailleur_apply_models.dart';

class BailleurApplyRemoteDataSource {
  BailleurApplyRemoteDataSource(this._dio);

  final Dio _dio;

  // Étape 1 : GET presigned URL  →  Étape 2 : PUT bytes directement vers MinIO
  Future<String> uploadDocument(List<int> bytes, String filename) async {
    try {
      final contentType = _contentTypeFromFilename(filename);

      // Étape 1 – Obtenir l'URL presignée
      final presignResp = await _dio.get(
        ApiEndpoints.storagePresignBailleurDocument,
        queryParameters: {'contentType': contentType, 'expires': 900},
      );
      final presignData =
          (presignResp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final uploadUrl = presignData['uploadUrl'] as String? ?? '';
      final publicUrl = presignData['publicUrl'] as String? ?? '';
      if (uploadUrl.isEmpty || publicUrl.isEmpty) {
        throw ApiException(message: 'Presign échoué — URL manquante');
      }

      // Étape 2 – PUT des bytes bruts vers MinIO (sans intercepteurs d'auth)
      final minioClient = Dio();
      await minioClient.put(
        uploadUrl,
        data: Stream.fromIterable(bytes.map((b) => [b])),
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': bytes.length,
          },
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      return publicUrl;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  static String _contentTypeFromFilename(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      _ => 'image/jpeg',
    };
  }

  Future<BailleurApplication> apply(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(ApiEndpoints.bailleurApply, data: body);

      final api = ApiResponse<BailleurApplication>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => BailleurApplication.fromJson(json! as Map<String, dynamic>),
      );

      final data = api.data;
      if (data == null) {
        throw ApiException(
          message: 'Réponse invalide du serveur',
          statusCode: api.statusCode,
        );
      }
      return data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
