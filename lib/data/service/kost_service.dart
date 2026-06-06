import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_clients.dart';
import '../model/kost_model.dart';

class KostService {
  /// Ambil semua daftar kost
  Future<List<KostModel>> getAllKost() async {
    final response = await ApiClient.get(ApiEndpoints.getAllKost);
    if (response['status'] == 'success') {
      final list = response['data'] as List<dynamic>;
      return list
          .map((e) => KostModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Ambil detail satu kost by ID
  Future<KostModel?> getDetailKost(int id) async {
    final response = await ApiClient.get(
      ApiEndpoints.getDetailKost,
      queryParams: {'id': id.toString()},
    );
    if (response['status'] == 'success') {
      return KostModel.fromJson(response['data'] as Map<String, dynamic>);
    }
    return null;
  }
}
