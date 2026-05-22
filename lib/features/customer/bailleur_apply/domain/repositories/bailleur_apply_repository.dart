import '../../data/models/bailleur_apply_models.dart';

abstract class BailleurApplyRepository {
  Future<String> uploadDocument(List<int> bytes, String filename);
  Future<BailleurApplication> apply(Map<String, dynamic> body);
}
