import 'package:ecommerce_app/services/dashboard_service.dart';

class DashboardRepository {

  final DashboardService _dashboardService = DashboardService();

  Future<dynamic> getDashboard(String status, DateTime startDate, DateTime endDate) => _dashboardService.getDashboard(status, startDate, endDate);

}