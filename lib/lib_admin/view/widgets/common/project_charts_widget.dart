import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/Models/project_model.dart';
import '../../../core/constant/responsive.dart';

class ProjectChartsWidget extends StatelessWidget {
  final ProjectModel project;

  const ProjectChartsWidget({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final totalTasks = project.totalTasks ?? 0;
    final completedTasks = project.completedTasks ?? 0;
    final pendingTasks = totalTasks - completedTasks;
    final progressPercentage = (project.progressPercentage ?? 0.0).clamp(0.0, 100.0);
    
    final hasTasks = totalTasks > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Responsive.spacing(context, mobile: 16)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tasks Distribution",
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, mobile: 16),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, mobile: 16)),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                      child: SizedBox(
                      height: 200,
                      child: hasTasks
                          ? PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: [
                                  if (completedTasks > 0)
                                    PieChartSectionData(
                                      value: completedTasks.toDouble(),
                                      title: '${((completedTasks / totalTasks) * 100).toStringAsFixed(0)}%',
                                      color: const Color(0xFF10B981),
                                      radius: 60,
                                      titleStyle: TextStyle(
                                        fontSize: Responsive.fontSize(context, mobile: 12),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  if (pendingTasks > 0)
                                    PieChartSectionData(
                                      value: pendingTasks.toDouble(),
                                      title: '${((pendingTasks / totalTasks) * 100).toStringAsFixed(0)}%',
                                      color: const Color(0xFFEF4444),
                                      radius: 60,
                                      titleStyle: TextStyle(
                                        fontSize: Responsive.fontSize(context, mobile: 12),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                "No tasks available",
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, mobile: 14),
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                          context,
                          "Completed",
                          completedTasks.toString(),
                          const Color(0xFF10B981),
                        ),
                        SizedBox(height: Responsive.spacing(context, mobile: 12)),
                        _buildLegendItem(
                          context,
                          "Pending",
                          pendingTasks.toString(),
                          const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 16)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Progress Overview",
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, mobile: 16),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, mobile: 16)),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, mobile: 12),
                                color: const Color(0xFF666666),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value == 50 || value == 100) {
                              return Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, mobile: 10),
                                  color: const Color(0xFF666666),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: const Color(0xFFE0E0E0),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: progressPercentage,
                            color: const Color(0xFF3B82F6),
                            width: 40,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, mobile: 12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${progressPercentage.toStringAsFixed(1)}% Complete",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, mobile: 14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 16)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tasks Comparison",
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, mobile: 16),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: Responsive.spacing(context, mobile: 16)),
              SizedBox(
                height: 200,
                child: hasTasks
                    ? BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: totalTasks > 0 ? totalTasks.toDouble() : 10,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value == 0) {
                                    return Text(
                                      'Completed',
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context, mobile: 12),
                                        color: const Color(0xFF666666),
                                      ),
                                    );
                                  } else if (value == 1) {
                                    return Text(
                                      'Pending',
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context, mobile: 12),
                                        color: const Color(0xFF666666),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() % 5 == 0 || value.toInt() == totalTasks) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context, mobile: 10),
                                        color: const Color(0xFF666666),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: const Color(0xFFE0E0E0),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: completedTasks.toDouble(),
                                  color: const Color(0xFF10B981),
                                  width: 30,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: pendingTasks.toDouble(),
                                  color: const Color(0xFFEF4444),
                                  width: 30,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          "No tasks available",
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, mobile: 14),
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, mobile: 12),
                  color: const Color(0xFF666666),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, mobile: 16),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

