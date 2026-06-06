import 'package:flutter/material.dart';
import '../data/model/kost_model.dart';
import '../data/service/kost_service.dart';

class KostProvider extends ChangeNotifier {
  final KostService _service = KostService();

  List<KostModel> _allKost = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KostModel> get allKost => _allKost;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllKost() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allKost = await _service.getAllKost();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
