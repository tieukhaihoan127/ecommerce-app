import 'package:ecommerce_app/models/dashboard.dart';
import 'package:ecommerce_app/repositories/dashboard_repository.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {

  final DashboardRepository _dashboardRepository = DashboardRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  DashboardModel? _dashboard;

  DashboardModel? get dashboard => _dashboard;


  Future<void> getDashboard(String status, DateTime? startDate, DateTime? endDate) async {
    
    _isLoading = true;
    notifyListeners();

    try {
      var filterStatus = "Week";

      if(status == "Weekly") {
        filterStatus = "Week";
      }
      else if(status == "Monthly") {
        filterStatus = "Month";
      }
      else if(status == "Quarter") {
        filterStatus = "Quarter";
      }
      else if(status == "Custom Range") {
        filterStatus = "Custom";
      }

      final response = await _dashboardRepository.getDashboard(filterStatus,startDate ?? DateTime.now(),endDate ?? DateTime.now());

      if(response != null) {
        _dashboard = DashboardModel.fromJson(response);

        _errorMessage = "";
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

  }

}