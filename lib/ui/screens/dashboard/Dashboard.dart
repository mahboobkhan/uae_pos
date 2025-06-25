import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final List<Map<String, dynamic>> stats = [
    {'label': 'Revenue', 'value': '25K'},
    {'label': 'Users', 'value': '1.2K'},
    {'label': 'Orders', 'value': '320'},
    {'label': 'Visits', 'value': '8.5K'},
    {'label': 'Returns', 'value': '102'},
  ];

  final List<PieChartSectionData> pieSections = [
    PieChartSectionData(value: 40, color: Colors.red, title: '40%'),
    PieChartSectionData(value: 30, color: Colors.blue, title: '30%'),
    PieChartSectionData(value: 15, color: Colors.green, title: '15%'),
    PieChartSectionData(value: 15, color: Colors.yellow, title: '15%'),
  ];

  final List<FlSpot> lineSpots = [
    FlSpot(0, 1),
    FlSpot(1, 1.5),
    FlSpot(2, 1.4),
    FlSpot(3, 3.4),
    FlSpot(4, 2),
    FlSpot(5, 2.2),
    FlSpot(6, 1.8),
  ];

  final List<BarChartGroupData> barGroups = List.generate(
    5,
    (i) => BarChartGroupData(
      x: i,
      barRods: [BarChartRodData(toY: (i + 1) * 1.0, color: Colors.red)],
    ),
  );

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
              // Top Cards
              SizedBox(
                height: 120,
                child: Row(
                  children:
                      stats.map((stat) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  stat['value'],
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  stat['label'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              // Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line Chart
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGraphHeader("Line Chart"),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: lineSpots,
                                  isCurved: false,
                                  dotData: FlDotData(show: true),
                                  color: Colors.red,
                                  belowBarData: BarAreaData(
                                    show: false,
                                    color: Colors.red.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Separator
                  Container(width: 1, height: 240, color: Colors.grey.shade300),
                  const SizedBox(width: 12),
                  // Bar Chart
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildGraphHeader("Bar Chart"),
                      SizedBox(
                        height: 200,
                        width: 300,
                        child: BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First Pie Chart with header
                    SizedBox(
                      width: width * 0.36,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildGraphHeader("Pie Chart 1"),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: pieSections,
                                sectionsSpace: 4,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12,),
                    Container(width: 1, height: 240, color: Colors.grey.shade300),
                    SizedBox(width: 12,),
                    SizedBox(
                      width: width * 0.36, // 45% of screen width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildGraphHeader("Pie Chart 2"),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: pieSections,
                                sectionsSpace: 4,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Pie Chart
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _startDate;
  DateTime? _endDate;

  Widget _buildGraphHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Graph Title
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

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
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 14),
                    label: const Text("Start", style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
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
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today, size: 14),
                    label: const Text("End", style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
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
                  if (_startDate != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "From: ${_startDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  if (_endDate != null)
                    Text(
                      "To: ${_endDate!.toLocal().toString().split(' ')[0]}",
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
}
