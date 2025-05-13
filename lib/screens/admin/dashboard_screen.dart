import 'package:ecommerce_app/core/config/responsive.dart';
import 'package:ecommerce_app/core/theme/constant.dart';
import 'package:ecommerce_app/models/dashboard.dart';
import 'package:ecommerce_app/providers/dashboard_provider.dart';
import 'package:ecommerce_app/screens/admin/header.dart';
import 'package:ecommerce_app/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String _selectedFilter = 'Weekly';

  DateTime? _startDate;

  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<DashboardProvider>(context, listen: false).getDashboard("Weekly", null, null);
    });
  }

  @override
  Widget build(BuildContext context) {

    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: dashboardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardProvider.dashboard == null
                ? const Center(child: Text("Không có dữ liệu!!!"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Header(),
                        const SizedBox(height: defaultPadding),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(defaultPadding),
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildFilterDropdown(dashboardProvider),
                                        const SizedBox(height: 16),
                                        buildOverviewCards(dashboardProvider.dashboard!),
                                        const SizedBox(height: 24),
                                        const Text("Biểu đồ Doanh thu",
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        const SizedBox(height: 16),
                                        AspectRatio(
                                          aspectRatio: 1.6,
                                          child: buildBarChart(
                                            dashboardProvider.dashboard!,
                                            _selectedFilter,
                                            _startDate,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
                                ],
                              ),
                            ),
                            if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );

  }

  Widget buildFilterDropdown(DashboardProvider dashboardProvider) {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedFilter,
          dropdownColor: secondaryColor,
          items: [
            'Weekly',
            'Monthly',
            'Quarter',
            'Custom Range',
          ].map((label) => DropdownMenuItem(
                value: label,
                child: Text(label, style: const TextStyle(color: Colors.white)),
              )).toList(),
          onChanged: (value) async {
            if (value == 'Custom Range') {
              final pickedStart = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
              );
              if (pickedStart == null) return;

              final pickedEndRaw = await showDatePicker(
                context: context,
                initialDate: pickedStart,
                firstDate: pickedStart,
                lastDate: DateTime.now(),
              );
              if (pickedEndRaw == null) return;

              final pickedEnd = DateTime(
                pickedEndRaw.year,
                pickedEndRaw.month,
                pickedEndRaw.day,
                23,
                59,
                59,
              );

              setState(() {
                _selectedFilter = value!;
                _startDate = pickedStart;
                _endDate = pickedEnd;
              });

              dashboardProvider.getDashboard(_selectedFilter, _startDate, _endDate);
            } else {
              setState(() {
                _selectedFilter = value!;
                _startDate = null;
                _endDate = null;
              });

              dashboardProvider.getDashboard(_selectedFilter, null, null);
            }
          },
        ),
        if (_selectedFilter == 'Custom Range' && _startDate != null && _endDate != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '${_startDate!.toLocal().toString().split(' ')[0]} → ${_endDate!.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
      ],
    );
  }

  Widget buildOverviewCards(DashboardModel stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            buildCard("Tổng người dùng", stats.totalUser.toString()),
            buildCard("Người dùng mới", stats.newUser.toString()),
            buildCard("Tổng đơn hàng", stats.totalOrders.toString()),
            buildCard("Doanh thu", "${_formatCurrency(stats.revenue!)} VND"),
            buildCard("Sản phẩm bán chạy", stats.totalBestSellingSold.toString()),
          ],
        );
      },
    );
  }

  Widget buildCard(String title, String value) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 35, 38, 63),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 35, 38, 63)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  List<String> generateLabels(String status, List<int> orderCountList, DateTime? startDate) {
    switch (status) {
      case 'Weekly':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'Monthly':
        return List.generate(12, (index) => 'T${index + 1}');
      case 'Quarter':
        return ['Q1', 'Q2', 'Q3', 'Q4'];
      case 'Custom Range':
        if (startDate != null) {
          return List.generate(orderCountList.length, (index) {
            final date = startDate.add(Duration(days: index));
            return '${date.day}/${date.month}';
          });
        }
        return List.generate(orderCountList.length, (index) => '$index');
      default:
        return List.generate(orderCountList.length, (index) => '$index');
    }
  }

  
  Widget buildBarChart(DashboardModel dashboard, String status, DateTime? startDate) {
    final orderData = dashboard.orderCountList ?? [];
    final revenueData = dashboard.revenueList ?? [];

    if (orderData.isEmpty && revenueData.isEmpty) {
      return const SizedBox();
    }

    final labels = generateLabels(status, orderData, startDate);

    final maxOrder = (orderData.isNotEmpty ? orderData.reduce((a, b) => a > b ? a : b) : 0);
    final maxRevenue = (revenueData.isNotEmpty ? revenueData.reduce((a, b) => a > b ? a : b) : 0) ~/ 1000000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Indicator(color: Colors.blue, text: 'Đơn hàng'),
            SizedBox(width: 16),
            Indicator(color: Colors.orange, text: 'Doanh thu (VND)'),
          ],
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              maxY: [
                ((maxOrder / 100).ceil() * 100).toDouble(),
                ((maxRevenue / 200).ceil() * 200).toDouble()
              ].reduce((a, b) => a > b ? a : b),
              barGroups: List.generate(orderData.length, (index) {
                final order = orderData[index];
                final revenue = index < revenueData.length ? revenueData[index] : 0;
                
                if (order == 0 && revenue == 0) {
                  return null;
                }

                return BarChartGroupData(
                  x: index,
                  barsSpace: 8,
                  barRods: [
                    BarChartRodData(
                      toY: order.toDouble(),
                      color: Colors.blue,
                      width: 7,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    BarChartRodData(
                      toY: revenue / 1000000, 
                      color: Colors.orange,
                      width: 7,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0, 1],
                );
              }).whereType<BarChartGroupData>().toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < labels.length) {
                        return Text(
                          labels[index],
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 100,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 500,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        "${value.toInt()}M",
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    if (rodIndex == 1) { 
                      final revenue = dashboard.revenueList![group.x.toInt()];
                      return BarTooltipItem(
                        "${_formatCurrency(revenue)} VND",
                        const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                      );
                    } else {
                      final orders = dashboard.orderCountList![group.x.toInt()];
                      return BarTooltipItem(
                        "$orders đơn",
                        const TextStyle(color: Colors.blueAccent),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

String _formatCurrency(int price) {
  final NumberFormat formatter = NumberFormat("#,##0", "vi_VN");
  return formatter.format(price);
}