import '../../domain/repositories/bailleur_apply_repository.dart';
import '../datasources/bailleur_apply_remote_data_source.dart';
import '../models/bailleur_apply_models.dart';

class BailleurApplyRepositoryImpl implements BailleurApplyRepository {
  BailleurApplyRepositoryImpl(this._remote);

  final BailleurApplyRemoteDataSource _remote;

  @override
  Future<String> uploadDocument(List<int> bytes, String filename) {
    return _remote.uploadDocument(bytes, filename);
  }

  @override
  Future<BailleurApplication> apply(Map<String, dynamic> body) {
    return _remote.apply(body);
  }
}
