import 'package:abc_consultant/utils/app_colors.dart';
import 'package:abc_consultant/utils/clipboard_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Date filters for each chart
  DateTime? _paymentsStartDate;
  DateTime? _paymentsEndDate;
  DateTime? _clientsStartDate;
  DateTime? _clientsEndDate;
  DateTime? _projectsStartDate;
  DateTime? _projectsEndDate;
  DateTime? _expensesStartDate;
  DateTime? _expensesEndDate;

  @override
  void initState() {
    super.initState();
    // Load all dashboard data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().getAllDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<DashboardProvider>(
                builder: (context, provider, child) {
                  if (provider.isOverviewLoading) {
                    return SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                  }

                  final stats = [
                    {'label': 'Revenue', 'value': provider.dashboardRevenueFormatted},
                    {'label': 'Users', 'value': provider.dashboardUsersFormatted},
                    {'label': 'Clients', 'value': provider.dashboardClientsFormatted},
                    {'label': 'Projects', 'value': provider.dashboardProjectsFormatted},
                    {'label': 'Expenses', 'value': provider.dashboardExpensesFormatted},
                  ];

                  return SizedBox(
                    height: 120,
                    child: Row(
                      children:
                          stats.map((stat) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color:AppColors.redColor, borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        stat['value'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontFamily: 'Courier',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        stat['label'] ?? '',
                                        style: const TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Charts Section with Provider Integration
              Consumer<DashboardProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      // Top Row: Payments Line Chart & Clients Bar Chart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payments Line Chart
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildGraphHeader(
                                  "Payments Chart",
                                  onStartDateChanged: (date) {
                                    setState(() => _paymentsStartDate = date);
                                    provider.setPaymentsFilters(
                                      startDate: date?.toIso8601String().split('T')[0],
                                      endDate: _paymentsEndDate?.toIso8601String().split('T')[0],
                                    );
                                    provider.refreshPaymentsData();
                                  },
                                  onEndDateChanged: (date) {
                                    setState(() => _paymentsEndDate = date);
                                    provider.setPaymentsFilters(
                                      startDate: _paymentsStartDate?.toIso8601String().split('T')[0],
                                      endDate: date?.toIso8601String().split('T')[0],
                                    );
                                    provider.refreshPaymentsData();
                                  },
                                  startDate: _paymentsStartDate,
                                  endDate: _paymentsEndDate,
                                ),
                                SizedBox(height: 200, child: _buildPaymentsChart(provider)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(width: 1, height: 240, color: Colors.grey.shade300),
                          const SizedBox(width: 12),
                          // Clients Bar Chart
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildGraphHeader(
                                "Clients Chart",
                                onStartDateChanged: (date) {
                                  setState(() => _clientsStartDate = date);
                                  provider.setClientsFilters(
                                    startDate: date?.toIso8601String().split('T')[0],
                                    endDate: _clientsEndDate?.toIso8601String().split('T')[0],
                                  );
                                  provider.refreshClientsData();
                                },
                                onEndDateChanged: (date) {
                                  setState(() => _clientsEndDate = date);
                                  provider.setClientsFilters(
                                    startDate: _clientsStartDate?.toIso8601String().split('T')[0],
                                    endDate: date?.toIso8601String().split('T')[0],
                                  );
                                  provider.refreshClientsData();
                                },
                                startDate: _clientsStartDate,
                                endDate: _clientsEndDate,
                              ),
                              SizedBox(height: 200, width: 300, child: _buildClientsChart(provider)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 24),

                      // Bottom Row: Projects Pie Chart & Expenses Pie Chart
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Projects Pie Chart
                            SizedBox(
                              width: width * 0.36,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildGraphHeader(
                                    "Projects Chart",
                                    onStartDateChanged: (date) {
                                      setState(() => _projectsStartDate = date);
                                      provider.setProjectsFilters(
                                        startDate: date?.toIso8601String().split('T')[0],
                                        endDate: _projectsEndDate?.toIso8601String().split('T')[0],
                                      );
                                      provider.refreshProjectsData();
                                    },
                                    onEndDateChanged: (date) {
                                      setState(() => _projectsEndDate = date);
                                      provider.setProjectsFilters(
                                        startDate: _projectsStartDate?.toIso8601String().split('T')[0],
                                        endDate: date?.toIso8601String().split('T')[0],
                                      );
                                      provider.refreshProjectsData();
                                    },
                                    startDate: _projectsStartDate,
                                    endDate: _projectsEndDate,
                                  ),
                                  SizedBox(height: 200, child: _buildProjectsChart(provider)),
                                  const SizedBox(height: 8),
                                  _buildProjectsLegend(provider),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(width: 1, height: 240, color: Colors.grey.shade300),
                            SizedBox(width: 12),
                            // Expenses Pie Chart
                            SizedBox(
                              width: width * 0.36,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildGraphHeader(
                                    "Expenses Chart",
                                    onStartDateChanged: (date) {
                                      setState(() => _expensesStartDate = date);
                                      provider.setExpensesFilters(
                                        startDate: date?.toIso8601String().split('T')[0],
                                        endDate: _expensesEndDate?.toIso8601String().split('T')[0],
                                      );
                                      provider.refreshExpensesData();
                                    },
                                    onEndDateChanged: (date) {
                                      setState(() => _expensesEndDate = date);
                                      provider.setExpensesFilters(
                                        startDate: _expensesStartDate?.toIso8601String().split('T')[0],
                                        endDate: date?.toIso8601String().split('T')[0],
                                      );
                                      provider.refreshExpensesData();
                                    },
                                    startDate: _expensesStartDate,
                                    endDate: _expensesEndDate,
                                  ),
                                  SizedBox(height: 200, child: _buildExpensesChart(provider)),
                                  const SizedBox(height: 8),
                                  _buildExpensesLegend(provider),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Payments Line Chart
  Widget _buildPaymentsChart(DashboardProvider provider) {
    if (provider.isPaymentsLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.paymentsErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.redColor, size: 48),
            SizedBox(height: 8),
            Text('Error loading payments data', style: TextStyle(color: AppColors.redColor)),
            SizedBox(height: 4),
            Text(
              provider.paymentsErrorMessage!,
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (provider.paymentsChartData.isEmpty) {
      return Center(child: Text('No payments data available'));
    }

    // Convert payments data to line chart spots and capture x labels (dates)
    final List<FlSpot> spots = [];
    final List<String> xLabels = [];
    for (int i = 0; i < provider.paymentsChartData.length; i++) {
      final dayData = provider.paymentsChartData[i];
      spots.add(FlSpot(i.toDouble(), (dayData['total_amount'] ?? 0).toDouble()));
      final String date = (dayData['date'] ?? '').toString();
      xLabels.add(date.isNotEmpty && date.length >= 10 ? date.substring(5) : date);
    }

    // Adaptive bottom label interval to avoid overlap
    final int maxBottomLabels = 6;
    final int bottomInterval =
        xLabels.isEmpty ? 1 : (xLabels.length <= maxBottomLabels ? 1 : (xLabels.length / maxBottomLabels).ceil());

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            dotData: FlDotData(show: true),
            color: AppColors.redColor,
            belowBarData: BarAreaData(show: true, color: AppColors.redColor.withOpacity(0.3)),
          ),
        ],
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: bottomInterval.toDouble(),
              getTitlesWidget: (value, meta) {
                final int index = value.toInt();
                if (index < 0 || index >= xLabels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(xLabels[index], style: const TextStyle(fontSize: 10, color: Colors.black54)),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }

  // Build Clients Bar Chart
  Widget _buildClientsChart(DashboardProvider provider) {
    if (provider.isClientsLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.clientsErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.redColor, size: 48),
            SizedBox(height: 8),
            Text('Error loading clients data', style: TextStyle(color: AppColors.redColor)),
          ],
        ),
      );
    }

    if (provider.clientsChartData.isEmpty) {
      return Center(child: Text('No clients data available'));
    }

    // Convert clients data to bar chart and capture x labels (dates)
    final List<BarChartGroupData> barGroups = [];
    final List<String> xLabels = [];
    double maxCount = 0;
    final int len = provider.clientsChartData.length;
    for (int i = 0; i < len; i++) {
      final dayData = provider.clientsChartData[i];
      final double count = ((dayData['total_clients'] ?? 0) as num).toDouble();
      if (count > maxCount) maxCount = count;
      barGroups.add(BarChartGroupData(x: i, barRods: [BarChartRodData(toY: count, color: AppColors.redColor)]));
      final String date = (dayData['date'] ?? '').toString();
      xLabels.add(date.isNotEmpty && date.length >= 10 ? date.substring(5) : date);
    }

    // Compute integer-friendly Y-axis max and interval
    final double computedMaxY = maxCount <= 1 ? 2 : (maxCount + 1).ceilToDouble();

    // // Adaptive bottom label interval to avoid overlap
    // final int maxBottomLabels = 6;
    // final int bottomInterval =
    //     xLabels.isEmpty ? 1 : (xLabels.length <= maxBottomLabels ? 1 : (xLabels.length / maxBottomLabels).ceil());

    // Keep labels minimal for smaller box: cap to ~4 labels
    final int maxBottomLabels = 4;
    final int bottomInterval =
        xLabels.isEmpty ? 1 : (xLabels.length <= maxBottomLabels ? 1 : (xLabels.length / maxBottomLabels).ceil());

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        minY: 0,
        maxY: computedMaxY,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, horizontalInterval: 1),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final int v = value.round();
                return Text('$v', style: const TextStyle(fontSize: 10, color: Colors.black54));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: bottomInterval.toDouble(),
              getTitlesWidget: (value, meta) {
                final int index = value.toInt();
                if (index < 0 || index >= xLabels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(xLabels[index], style: const TextStyle(fontSize: 10, color: Colors.black54)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Build Projects Pie Chart
  Widget _buildProjectsChart(DashboardProvider provider) {
    if (provider.isProjectsLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.projectsErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.redColor, size: 48),
            SizedBox(height: 8),
            Text('Error loading projects data', style: TextStyle(color: AppColors.redColor)),
          ],
        ),
      );
    }

    if (provider.projectsStatusDistribution == null || provider.projectsStatusDistribution!.isEmpty) {
      return Center(child: Text('No projects data available'));
    }

    // Convert projects status distribution to pie chart
    List<PieChartSectionData> sections = [];
    List<Color> colors = [Colors.green, Colors.blue, Colors.orange, AppColors.redColor, Colors.purple];

    for (int i = 0; i < provider.projectsStatusDistribution!.length; i++) {
      final statusData = provider.projectsStatusDistribution![i];
      final percentage = (statusData['percentage'] ?? 0).toDouble();

      if (percentage > 0) {
        sections.add(
          PieChartSectionData(
            value: percentage,
            color: colors[i % colors.length],
            title: '${percentage.toStringAsFixed(1)}%',
            titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }
    }

    return PieChart(PieChartData(sections: sections, sectionsSpace: 4, centerSpaceRadius: 40));
  }

  // Legend for Projects Pie
  Widget _buildProjectsLegend(DashboardProvider provider) {
    final data = provider.projectsStatusDistribution ?? [];
    if (data.isEmpty) return const SizedBox.shrink();
    final List<Color> colors = [Colors.green, Colors.blue, Colors.orange, AppColors.redColor, Colors.purple];

    final List<Widget> items = [];
    for (int i = 0; i < data.length; i++) {
      final m = data[i];
      final num pct = (m['percentage'] ?? 0) is num ? m['percentage'] : 0;
      if (pct == 0) continue; // show only categories present in chart
      final String label = (m['status'] ?? '').toString();
      items.add(_LegendItem(color: colors[i % colors.length], label: label));
    }

    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 12, runSpacing: 8, children: items);
  }

  // Build Expenses Pie Chart
  Widget _buildExpensesChart(DashboardProvider provider) {
    if (provider.isExpensesLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.expensesErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.redColor, size: 48),
            SizedBox(height: 8),
            Text('Error loading expenses data', style: TextStyle(color: AppColors.redColor)),
          ],
        ),
      );
    }

    if (provider.expensesTypeDistribution == null || provider.expensesTypeDistribution!.isEmpty) {
      return Center(child: Text('No expenses data available'));
    }

    // Convert expenses type distribution to pie chart
    List<PieChartSectionData> sections = [];
    List<Color> colors = [AppColors.redColor, Colors.blue, Colors.green, Colors.yellow, Colors.purple];

    for (int i = 0; i < provider.expensesTypeDistribution!.length; i++) {
      final typeData = provider.expensesTypeDistribution![i];
      final percentage = (typeData['percentage'] ?? 0).toDouble();

      if (percentage > 0) {
        sections.add(
          PieChartSectionData(
            value: percentage,
            color: colors[i % colors.length],
            title: '${percentage.toStringAsFixed(1)}%',
            titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }
    }

    return PieChart(PieChartData(sections: sections, sectionsSpace: 4, centerSpaceRadius: 40));
  }

  // Updated graph header with individual date filters
  Widget _buildGraphHeader(
    String title, {
    required Function(DateTime?) onStartDateChanged,
    required Function(DateTime?) onEndDateChanged,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Graph Title
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          // Right side: Start/End Date Filters
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  // Start Date Button
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        onStartDateChanged(picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 14),
                    label: const Text("Start", style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: const Size(10, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // End Date Button
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        onEndDateChanged(picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 14),
                    label: const Text("End", style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: const Size(10, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),

              // Date Texts
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (startDate != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "From: ${startDate.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                  if (endDate != null)
                    Text(
                      "To: ${endDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Legend for Expenses Pie
  Widget _buildExpensesLegend(DashboardProvider provider) {
    final data = provider.expensesTypeDistribution ?? [];
    if (data.isEmpty) return const SizedBox.shrink();
    final List<Color> colors = [AppColors.redColor, Colors.blue, Colors.green, Colors.yellow, Colors.purple];

    final List<Widget> items = [];
    for (int i = 0; i < data.length; i++) {
      final m = data[i];
      final num pct = (m['percentage'] ?? 0) is num ? m['percentage'] : 0;
      if (pct == 0) continue; // show only categories present in chart
      final String label = (m['type'] ?? '').toString();
      items.add(_LegendItem(color: colors[i % colors.length], label: label));
    }

    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 12, runSpacing: 8, children: items);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(ClipboardUtils.capitalizeFirstLetter(label), style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}
