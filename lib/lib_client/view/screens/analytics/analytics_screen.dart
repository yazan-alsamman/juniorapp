import 'package:flutter/material.dart';
import 'package:project_hub/lib_client/controller/common/custom_drawer_controller.dart';
import 'package:get/get.dart';
import 'package:project_hub/lib_client/core/constant/color.dart';
import 'package:project_hub/lib_client/core/constant/responsive.dart';
import 'package:project_hub/lib_client/controller/common/analytics_controller.dart';
import 'package:project_hub/lib_client/view/widgets/custom_app_bar.dart';
import 'package:project_hub/lib_client/view/widgets/common/custom_drawer.dart';
import 'package:project_hub/lib_client/view/widgets/common/header.dart';
import 'package:project_hub/lib_client/view/widgets/common/analytics_card.dart';
import 'package:project_hub/lib_client/view/widgets/common/project_status_card.dart';
import 'package:project_hub/lib_client/view/widgets/common/productivity_card.dart';
import 'package:project_hub/lib_client/view/widgets/common/upcoming_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Only register if not already registered from lib_client
    if (!Get.isRegistered<CustomDrawerControllerImp>()) {
      Get.put(CustomDrawerControllerImp());
    }
    // Force update the analytics controller to use lib_client version
    if (Get.isRegistered<AnalyticsControllerImp>()) {
      Get.delete<AnalyticsControllerImp>();
    }
    Get.put(AnalyticsControllerImp());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const CustomAppBar(showBackButton: false),
      drawer: Responsive.isMobile(context) ? const CustomDrawer() : null,
      body: Row(
        children: [
          if (!Responsive.isMobile(context)) const CustomDrawer(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.spacing(context, mobile: 16),
                vertical: Responsive.spacing(context, mobile: 24),
              ),
              child: GetBuilder<AnalyticsControllerImp>(
                builder: (controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      title: "Analytics",
                      subtitle: "Track your project metrics and performance",
                      haveButton: false,
                    ),
                    SizedBox(height: Responsive.spacing(context, mobile: 24)),

                    // Project Selector
                    _buildProjectSelector(context, controller),
                    SizedBox(height: Responsive.spacing(context, mobile: 24)),

                    Obx(() {
                      if (controller.selectedProjectId.value.isEmpty ||
                          controller.selectedProjectId.value == 'all') {
                        // Show dashboard overview
                        return _buildDashboardOverview(context, controller);
                      } else {
                        // Show project-specific analytics
                        return _buildProjectAnalytics(context, controller);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSelector(
    BuildContext context,
    AnalyticsControllerImp controller,
  ) {
    return Obx(() {
      if (controller.projects.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, mobile: 16),
          vertical: Responsive.spacing(context, mobile: 12),
        ),
        decoration: BoxDecoration(
          color: AppColor.cardBackgroundColor,
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, mobile: 12),
          ),
          border: Border.all(color: AppColor.borderColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.folder_outlined,
              color: AppColor.textSecondaryColor,
              size: Responsive.iconSize(context, mobile: 20),
            ),
            SizedBox(width: Responsive.spacing(context, mobile: 12)),
            Expanded(
              child: DropdownButton<String>(
                value: controller.selectedProjectId.value,
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text(
                  'All Projects',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, mobile: 14),
                    color: AppColor.textColor,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: 'all',
                    child: Text('Dashboard Overview'),
                  ),
                  ...controller.projects.map((project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(
                        project.title,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, mobile: 14),
                          color: AppColor.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ],
                onChanged: (String? projectId) {
                  if (projectId != null) {
                    controller.selectProject(projectId);
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDashboardOverview(
    BuildContext context,
    AnalyticsControllerImp controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsCard(
          title: "Overall Project Completion",
          value:
              "${(controller.averageProjectCompletion.value * 100).round()}%",
          subtitle: "Average across all projects",
          icon: Icons.trending_up,
          gradientColors: [const Color(0xFF2196F3), const Color(0xFF1565C0)],
          iconBackgroundColor: const Color(0xFF42A5F5),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 16)),
        AnalyticsCard(
          title: "Overall Task Completion",
          value: "${(controller.overallCompletion.value * 100).round()}%",
          subtitle: "Completed tasks / total tasks",
          icon: Icons.check_circle_outline,
          gradientColors: [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
          iconBackgroundColor: const Color(0xFF66BB6A),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 16)),
        AnalyticsCard(
          title: "Total Projects",
          value: "${controller.totalProjects.value}",
          subtitle: "Active and completed",
          icon: Icons.folder,
          gradientColors: [const Color(0xFF9C27B0), const Color(0xFF6A1B9A)],
          iconBackgroundColor: const Color(0xFFBA68C8),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 24)),
        Container(
          margin: EdgeInsets.only(
            bottom: Responsive.spacing(context, mobile: 20),
          ),
          child: Obx(() {
            return ProjectStatusCard(
              title: "Projects by Status",
              statuses: controller.projectStatuses
                  .map(
                    (s) => ProjectStatus(
                      label: s.label,
                      count: s.count,
                      percentage: s.percentage,
                      color: s.color,
                    ),
                  )
                  .toList(),
            );
          }),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 24)),
        Container(
          margin: EdgeInsets.only(
            bottom: Responsive.spacing(context, mobile: 20),
          ),
          child: ProductivityCard(
            title: "Team Productivity",
            teamMembers: [
              TeamMember(name: "John Dev", score: "18/24", percentage: 75.0),
              TeamMember(
                name: "Sarah Design",
                score: "14/16",
                percentage: 87.5,
              ),
              TeamMember(
                name: "Alex Backend",
                score: "22/28",
                percentage: 78.5,
              ),
              TeamMember(name: "Lisa QA", score: "15/20", percentage: 75.0),
            ],
          ),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 24)),
        Container(
          margin: EdgeInsets.only(
            bottom: Responsive.spacing(context, mobile: 20),
          ),
          child: UpcomingCard(
            title: "Upcoming Milestones",
            milestones: [
              Milestone(
                name: "E-Commerce Platform Launch",
                date: "Dec 15, 2024",
                status: "critical",
                icon: Icons.warning,
                iconColor: const Color(0xFFE53E3E),
                statusColor: const Color(0xFFFED7D7),
                statusTextColor: const Color(0xFFC53030),
              ),
              Milestone(
                name: "API Integration Completion",
                date: "Dec 31, 2024",
                status: "on-track",
                icon: Icons.check,
                iconColor: const Color(0xFF38A169),
                statusColor: const Color(0xFFC6F6D5),
                statusTextColor: const Color(0xFF2F855A),
              ),
              Milestone(
                name: "Dashboard System Release",
                date: "Jan 20, 2025",
                status: "on-track",
                icon: Icons.check,
                iconColor: const Color(0xFF38A169),
                statusColor: const Color(0xFFC6F6D5),
                statusTextColor: const Color(0xFF2F855A),
              ),
              Milestone(
                name: "Blockchain Integration Launch",
                date: "Feb 28, 2025",
                status: "planning",
                icon: Icons.check,
                iconColor: const Color(0xFF38A169),
                statusColor: const Color(0xFFBEE3F8),
                statusTextColor: const Color(0xFF2B6CB0),
              ),
            ],
          ),
        ),
        SizedBox(height: Responsive.spacing(context, mobile: 32)),
      ],
    );
  }

  Widget _buildProjectAnalytics(
    BuildContext context,
    AnalyticsControllerImp controller,
  ) {
    return Obx(() {
      if (controller.projectAnalytics.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final analytics = controller.projectAnalytics.value!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project title
          Text(
            'Project Analytics',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 24),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),

          // Overview Card
          _buildProjectOverviewCard(context, analytics),
          SizedBox(height: Responsive.spacing(context, mobile: 24)),

          // Task Status Chart
          _buildTaskStatusChart(context, analytics),
          SizedBox(height: Responsive.spacing(context, mobile: 24)),

          // Priority Distribution
          _buildPriorityDistribution(context, analytics),
          SizedBox(height: Responsive.spacing(context, mobile: 24)),

          // Role Distribution
          _buildRoleDistribution(context, analytics),
          SizedBox(height: Responsive.spacing(context, mobile: 24)),

          // Timeline Info
          _buildTimelineInfo(context, analytics),
          SizedBox(height: Responsive.spacing(context, mobile: 24)),

          // Top Assignees
          _buildTopAssignees(context, analytics),
          SizedBox(height: Responsive.spacing(context, mobile: 32)),
        ],
      );
    });
  }

  Widget _buildProjectOverviewCard(
    BuildContext context,
    Map<String, dynamic> analytics,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 20)),
      decoration: BoxDecoration(
        color: AppColor.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Overview',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricBox(
                context,
                'Progress',
                '${((analytics['progress'] as double? ?? 0.0) * 100).toStringAsFixed(0)}%',
                AppColor.primaryColor,
                Icons.trending_up,
              ),
              _buildMetricBox(
                context,
                'Days Left',
                '${analytics['daysRemaining'] as int? ?? 0}',
                AppColor.inProgressColor,
                Icons.calendar_today,
              ),
              _buildMetricBox(
                context,
                'Status',
                ((analytics['status'] as String?) ?? 'planned').toUpperCase(),
                _getStatusColor((analytics['status'] as String?) ?? 'planned'),
                Icons.info_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Responsive.spacing(context, mobile: 8),
        ),
        padding: EdgeInsets.all(Responsive.spacing(context, mobile: 16)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(context, mobile: 12),
          ),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: Responsive.iconSize(context, mobile: 24),
            ),
            SizedBox(height: Responsive.spacing(context, mobile: 8)),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, mobile: 14),
                fontWeight: FontWeight.bold,
                color: AppColor.textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Responsive.spacing(context, mobile: 4)),
            Text(
              label,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, mobile: 10),
                color: AppColor.textSecondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskStatusChart(
    BuildContext context,
    Map<String, dynamic> analytics,
  ) {
    final completed = analytics['completed'] as double? ?? 0.0;
    final inProgress = analytics['inProgress'] as double? ?? 0.0;
    final pending = analytics['pending'] as double? ?? 0.0;

    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 20)),
      decoration: BoxDecoration(
        color: AppColor.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Status Distribution',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: Responsive.size(context, mobile: 160),
                  height: Responsive.size(context, mobile: 160),
                  child: CustomPaint(
                    painter: TaskStatusDonutPainter(
                      completed: completed,
                      inProgress: inProgress,
                      pending: pending,
                    ),
                  ),
                ),
                SizedBox(width: Responsive.spacing(context, mobile: 32)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusLegend(
                      context,
                      AppColor.completedColor,
                      'Completed',
                      '${(completed * 100).round()}%',
                    ),
                    SizedBox(height: Responsive.spacing(context, mobile: 12)),
                    _buildStatusLegend(
                      context,
                      AppColor.inProgressColor,
                      'In Progress',
                      '${(inProgress * 100).round()}%',
                    ),
                    SizedBox(height: Responsive.spacing(context, mobile: 12)),
                    _buildStatusLegend(
                      context,
                      AppColor.pendingColor,
                      'Pending',
                      '${(pending * 100).round()}%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLegend(
    BuildContext context,
    Color color,
    String label,
    String percentage,
  ) {
    return Row(
      children: [
        Container(
          width: Responsive.size(context, mobile: 12),
          height: Responsive.size(context, mobile: 12),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: Responsive.spacing(context, mobile: 8)),
        Text(
          '$label • $percentage',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, mobile: 14),
            color: AppColor.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDistribution(
    BuildContext context,
    Map<String, dynamic> analytics,
  ) {
    final priorityMap =
        analytics['priorityDistribution'] as Map<String, int>? ?? {};

    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 20)),
      decoration: BoxDecoration(
        color: AppColor.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tasks by Priority',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),
          if (priorityMap.isEmpty)
            Center(
              child: Text(
                'No tasks',
                style: TextStyle(color: AppColor.textSecondaryColor),
              ),
            )
          else
            Column(
              children: priorityMap.entries.map((entry) {
                final priority = entry.key;
                final count = entry.value;
                final total = analytics['totalTasks'] as int? ?? 1;
                final percentage = (count / total) * 100;
                final color = _getPriorityColor(priority);

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Responsive.spacing(context, mobile: 16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            priority,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 14,
                              ),
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$count tasks (${percentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 12,
                              ),
                              color: AppColor.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.spacing(context, mobile: 8)),
                      Container(
                        width: double.infinity,
                        height: Responsive.size(context, mobile: 8),
                        decoration: BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildRoleDistribution(
    BuildContext context,
    Map<String, dynamic> analytics,
  ) {
    final backend = analytics['backendTasks'] as int? ?? 0;
    final frontend = analytics['frontendTasks'] as int? ?? 0;

    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 20)),
      decoration: BoxDecoration(
        color: AppColor.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tasks by Role',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),
          Row(
            children: [
              Expanded(
                child: _buildRoleCard(
                  context,
                  'Backend',
                  backend,
                  AppColor.primaryColor,
                  Icons.code,
                ),
              ),
              SizedBox(width: Responsive.spacing(context, mobile: 16)),
              Expanded(
                child: _buildRoleCard(
                  context,
                  'Frontend',
                  frontend,
                  AppColor.secondaryColor,
                  Icons.palette,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    String role,
    int count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 16)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 12),
        ),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: Responsive.iconSize(context, mobile: 28),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 8)),
          Text(
            '$count',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 24),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 4)),
          Text(
            role,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 14),
              color: AppColor.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineInfo(
    BuildContext context,
    Map<String, dynamic> analytics,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 20)),
      decoration: BoxDecoration(
        color: AppColor.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Timeline',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),
          _buildTimelineItem(
            context,
            'Start Date',
            analytics['startDate'] as String? ?? 'N/A',
            Icons.flag_outlined,
            AppColor.primaryColor,
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 16)),
          _buildTimelineItem(
            context,
            'End Date',
            analytics['endDate'] as String? ?? 'N/A',
            Icons.flag_outlined,
            AppColor.inProgressColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(Responsive.spacing(context, mobile: 12)),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(
            icon,
            color: color,
            size: Responsive.iconSize(context, mobile: 20),
          ),
        ),
        SizedBox(width: Responsive.spacing(context, mobile: 16)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, mobile: 12),
                color: AppColor.textSecondaryColor,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, mobile: 16),
                fontWeight: FontWeight.w600,
                color: AppColor.textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopAssignees(
    BuildContext context,
    Map<String, dynamic> analytics,
  ) {
    final assignees = analytics['assignees'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(Responsive.spacing(context, mobile: 20)),
      decoration: BoxDecoration(
        color: AppColor.cardBackgroundColor,
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(context, mobile: 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Workload',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, mobile: 18),
              fontWeight: FontWeight.bold,
              color: AppColor.textColor,
            ),
          ),
          SizedBox(height: Responsive.spacing(context, mobile: 20)),
          if (assignees.isEmpty)
            Center(
              child: Text(
                'No assignments yet',
                style: TextStyle(color: AppColor.textSecondaryColor),
              ),
            )
          else
            Column(
              children: assignees.take(5).map((item) {
                final assignee = item as Map<String, dynamic>;
                final name = assignee['name'] as String? ?? 'Unknown';
                final taskCount = assignee['taskCount'] as int? ?? 0;
                final percentage = assignee['percentage'] as double? ?? 0.0;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: Responsive.spacing(context, mobile: 16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 14,
                              ),
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$taskCount tasks',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(
                                context,
                                mobile: 12,
                              ),
                              color: AppColor.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Responsive.spacing(context, mobile: 8)),
                      Container(
                        width: double.infinity,
                        height: Responsive.size(context, mobile: 6),
                        decoration: BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.primaryColor,
                                    AppColor.secondaryColor,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    final p = priority.toLowerCase();
    if (p.contains('critical') || p.contains('high')) {
      return const Color(0xFFEF4444);
    } else if (p.contains('medium high') || p.contains('medium-high')) {
      return const Color(0xFFF59E0B);
    } else if (p.contains('medium')) {
      return const Color(0xFFFBBF24);
    } else if (p.contains('low medium') || p.contains('low-medium')) {
      return const Color(0xFF84CC16);
    } else if (p.contains('low')) {
      return const Color(0xFF10B981);
    }
    return const Color(0xFF6B7280);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColor.completedColor;
      case 'active':
        return AppColor.inProgressColor;
      case 'planned':
        return AppColor.pendingColor;
      default:
        return AppColor.textSecondaryColor;
    }
  }
}

class TaskStatusDonutPainter extends CustomPainter {
  final double completed;
  final double inProgress;
  final double pending;

  TaskStatusDonutPainter({
    required this.completed,
    required this.inProgress,
    required this.pending,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 25.0;

    final completedPaint = Paint()
      ..color = AppColor.completedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final inProgressPaint = Paint()
      ..color = AppColor.inProgressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final pendingPaint = Paint()
      ..color = AppColor.pendingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -3.14159 / 2;

    if (completed > 0) {
      final completedSweep = 2 * 3.14159 * completed;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        completedSweep,
        false,
        completedPaint,
      );
      startAngle += completedSweep;
    }

    if (inProgress > 0) {
      final inProgressSweep = 2 * 3.14159 * inProgress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        inProgressSweep,
        false,
        inProgressPaint,
      );
      startAngle += inProgressSweep;
    }

    if (pending > 0) {
      final pendingSweep = 2 * 3.14159 * pending;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pendingSweep,
        false,
        pendingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is TaskStatusDonutPainter &&
        (oldDelegate.completed != completed ||
            oldDelegate.inProgress != inProgress ||
            oldDelegate.pending != pending);
  }
}
