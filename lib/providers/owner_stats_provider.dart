import 'package:flutter/material.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_clients.dart';
import '../data/model/owner_stats_model.dart';

class OwnerStatsProvider extends ChangeNotifier {
  OwnerStatsModel? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  OwnerStatsModel? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStats(int pemilikId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient.get(
        ApiEndpoints.ownerStats,
        queryParams: {'pemilik_id': pemilikId.toString()},
      );
      if (response['status'] == 'success') {
        _stats =
            OwnerStatsModel.fromJson(response['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
